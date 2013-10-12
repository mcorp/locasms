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
    # @return [String]
    #
    # @example Calling with no extra parameters
    #
    #     client = LocaSMS::RestClient('http://localhost:3000', lgn: 'LOGIN', pwd: 'PASSWORD')
    #     # => GET http://localhost:3000?lgn=LOGIN&pws=PASSWORD&action=getballance
    #     client.get :getballance
    #
    # @example Calling with extra parameters
    #
    #     client = LocaSMS::RestClient('http://localhost:3000', lgn: 'LOGIN', pwd: 'PASSWORD')
    #     # => GET http://localhost:3000?lgn=LOGIN&pws=PASSWORD&action=holdsms&id=345678
    #     client.get :holdsms, id: 345678
    #
    # @see https://github.com/mcorp/locasms/wiki/A-API-de-envio#lista-das-a%C3%A7%C3%B5es-dispon%C3%ADveis List of avaiable actions
    def get(action, params={})
      params   = params_for action, params
      response = ::RestClient.get base_url, params: params
      JSON.parse(response) rescue response
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
      {action: action}.merge(base_params).merge(params)
    end
  end

end