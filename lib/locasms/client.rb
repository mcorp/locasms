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

    # Sends a message to one or more mobiles
    # @param [String] message message to be sent
    # @param [String,Array<String>] mobiles number of the mobiles to address the message
    # @return [String] campaign id on success
    def deliver(message, *mobiles)
      rest.get :sendsms, msg: message, numbers: mobiles.join(',')
    end

    # Schedule the send of a message to one or more mobiles
    # @param [String] message message to be sent
    # @param [Time,DateTime,Fixnum,String] datetime
    # @param [String,Array<String>] mobiles number of the mobiles to address the message
    # @return UNDEF
    def deliver_at(message, datetime, *mobiles)
      date, time = Helpers::DateTimeHelper.split datetime
      rest.get :sendsms, msg: message, numbers: mobiles.join(','), jobdate: date, jobtime: time
    end

    # Get de current amount of sending credits
    # @return [Fixnum] returns the balance on success
    def balance
      rest.get :getbalance
    end

    # Gets the current status of the given campaign
    # @param [String] id campaign id
    # @return UNDEF
    def campaign_status(id)
      rest.get :getstatus, id: id
    end

    # Holds the given campaign to fire
    # @param [String] id campaign id
    # @return [TrueClass,FalseClass] returns true on success
    def campaign_hold(id)
      rest.get :holdsms, id: id
    end

    # Restart firing the given campaign
    # @param [String] id campaign id
    # @return [TrueClass,FalseClass] returns true on success
    def campaign_release(id)
      rest.get :releasesms, id: id
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