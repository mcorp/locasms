module LocaSMS

  # Client to interact with LocaSMS API
  class Client
    # Default API address
    ENDPOINT = 'http://173.44.33.18/painel/api.ashx'

    attr_reader :login, :password

    # @param [String] login authorized user
    # @param [String] password access password
    # @param [Hash] opts
    # @option opts :rest_client (RestClient) client to be used to handle http requests
    def initialize(login, password, opts={})
      @login    = login
      @password = password

      @rest = opts[:rest_client]
    end

  private

    # Gets the current RestClient to handle http requests
    # @return [RestClient] you can set on class creation passing it on the options
    # @private
    def rest
      @rest ||= RestClient.new ENDPOINT, lgn: login, pwd: password
    end
  end

end