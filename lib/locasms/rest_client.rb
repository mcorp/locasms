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
  end

end