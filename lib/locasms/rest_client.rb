require 'json'
require 'net/http'

module LocaSMS

  # Class that handle http calls to LocaSMS api
  # @see https://github.com/mcorp/locasms/wiki/A-API-de-envio List of avaiable services
  class RestClient
    attr_accessor :base_url, :base_params

    # Creates a new instance of the RestClient class
    # @param [String] base_url a well formed url
    # @param [Hash] base_params base params to send on every call
    def initialize(base_url, base_params={})
      @base_url    = base_url
      @base_params = base_params
    end

    # Performs a GET call for an action
    # @param [String, Symbol] action the given action to perform
    # @param [Hash] params given parameters to send
    # @return [Hash] json parsed response
    #
    # @example Calling with no extra parameters
    #
    #     client = LocaSMS::RestClient('http://localhost:3000', lgn: 'LOGIN', pwd: 'PASSWORD')
    #     # => GET http://localhost:3000?lgn=LOGIN&pws=PASSWORD&action=getballance
    #     client.get :getballance
    #     # => {"status"=>1,"data"=>341,"msg"=>nil}
    #
    # @example Calling with extra parameters
    #
    #     client = LocaSMS::RestClient('http://localhost:3000', lgn: 'LOGIN', pwd: 'PASSWORD')
    #     # => GET http://localhost:3000?lgn=LOGIN&pws=PASSWORD&action=holdsms&id=345678
    #     client.get :holdsms, id: 345678
    #     # => {"status"=>1,"data"=>nil,"msg"=>"SUCESSO"}
    #
    # @see https://github.com/mcorp/locasms/wiki/A-API-de-envio#lista-das-a%C3%A7%C3%B5es-dispon%C3%ADveis List of avaiable actions
    # @raise [LocaSMS::InvalidOperation] when asked for an invalid operation
    # @raise [LocaSMS::InvalidLogin] when the given credentials are invalid
    def get(action, params={})
      params   = params_for action, params

      uri = URI.parse(base_url)
      uri.query = URI.encode_www_form(params)
      response = Net::HTTP.get_response(uri).body

      parse_response(action, response)
    end

    # Composes the parameters hash
    # @param [String, Symbol] action the given action to perform
    # @param [Hash] params given parameters to send
    # @return [Hash]
    #
    # @example
    #
    #    client = LocaSMS::RestClient('http://localhost:3000', lgn: 'LOGIN', pwd: 'PASSWORD')
    #    client.params_for :ACTION, a: 1, b: 2
    #    # => { action: :ACTION, lgn: 'LOGIN', pwd: 'PASSWORD', a: 1, b: 2 }
    #
    # @see https://github.com/mcorp/locasms/wiki/A-API-de-envio#lista-das-a%C3%A7%C3%B5es-dispon%C3%ADveis List of avaiable actions
    def params_for(action, params={})
      { action: action }.merge(base_params).merge(params)
    end

    # Parses a result trying to get it in json
    # @param [String, Symbol] action the given action to perform
    # @param [String] response body
    # @return [Hash] json parsed response
    # @raise [LocaSMS::InvalidOperation] when asked for an invalid operation
    # @raise [LocaSMS::InvalidLogin] when the given credentials are invalid
    def parse_response(action, response)
      raise InvalidOperation.new(action: action) if response =~ /^0:OPERACAO INVALIDA$/i

      j = JSON.parse(response) rescue { 'status' => 1, 'data' => response, 'msg' => nil }

      return j if j['status'] == 1 or action == :getstatus

      raise InvalidLogin.new(action: action) if j['msg'] =~ /^falha ao realizar login$/i
      raise Exception.new(message: j['msg'], raw: response, action: action)
    end
  end

end
