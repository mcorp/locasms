module LocaSMS

  # Client to interact with LocaSMS API
  class Client
    # Default API "domain"
    DOMAIN = '54.173.24.177'.freeze

    # Default API address
    ENDPOINT = {
      default:   "http://#{DOMAIN}/painel/api.ashx",
      shortcode: "http://#{DOMAIN}/shortcode/api.ashx"
    }.freeze

    attr_reader :login, :password, :type, :callback

    # @param [String] login authorized user
    # @param [String] password access password
    # @param [Hash] opts
    # @option opts :rest_client (RestClient) client to be used to handle http requests
    def initialize(login, password, opts={})
      @login    = login
      @password = password
      @type     = opts[:type] || :default
      @rest     = opts[:rest_client]
      @callback = opts[:url_callback]
    end

    # Sends a message to one or more mobiles
    # @param [String] message message to be sent
    # @param [String,Array<String>] mobiles number of the mobiles to address the message
    # @return [String] campaign id on success
    # @raise [LocaSMS::Exception] if bad numbers were given
    def deliver(message, *mobiles, **opts)
      attrs = {
        msg: message,
        numbers: numbers(mobiles),
        url_callback: callback
      }.merge(opts)
      rest.get(:sendsms, attrs)['data']
    end

    # Schedule the send of a message to one or more mobiles
    # @param [String] message message to be sent
    # @param [Time,DateTime,Fixnum,String] datetime
    # @param [String,Array<String>] mobiles number of the mobiles to address the message
    # @return UNDEF
    # @raise [LocaSMS::Exception] if bad numbers were given
    def deliver_at(message, datetime, *mobiles, **opts)
      date, time = Helpers::DateTimeHelper.split datetime
      attrs = {
        msg: message,
        numbers: numbers(mobiles),
        jobdate: date,
        jobtime: time,
        url_callback: callback
      }.merge(opts)
      rest.get(:sendsms, attrs)['data']
    end

    # Get de current amount of sending credits
    # @return [Fixnum] returns the balance on success
    def balance
      rest.get(:getbalance)['data']
    end

    # Gets the current status of the given campaign
    # @param [String] id campaign id
    # @return [Array<Hash>] {campaign_id: id, delivery_id: delivery_id, enqueue_time: enqueue_time, delivery_time: delivery_time, status: status, carrier: carrier, mobile_number: mobile_number, message: message }
    def campaign_status(id)
      response = rest.get(:getstatus, id: id)
      begin
        CSV.new(response['data'] || '', col_sep: ';', quote_char: '"').map do |delivery_id, _, enqueue_time, _, delivery_time, _, status, _, _, carrier, mobile_number, _, message|
          status = if status =~ /aguardando envio/i
            :waiting
          elsif status =~ /sucesso/i
            :success
          elsif status =~ /numero invalido|nao cadastrado/i
            :invalid
          else
            :unknown
          end

          {
            campaign_id: id,
            delivery_id: delivery_id,
            enqueue_time: enqueue_time,
            delivery_time: delivery_time,
            status: status,
            carrier: carrier,
            mobile_number: mobile_number,
            message: message
          }
        end
      rescue
        raise Exception.new 'Invalid delivery response data'
      end
    end

    # Holds the given campaign to fire
    # @param [String] id campaign id
    # @return [TrueClass,FalseClass] returns true on success
    def campaign_hold(id)
      rest.get(:holdsms, id: id)['data']
    end

    # Restart firing the given campaign
    # @param [String] id campaign id
    # @return [TrueClass,FalseClass] returns true on success
    def campaign_release(id)
      rest.get(:releasesms, id: id)['data']
    end

    private

    # Gets the current RestClient to handle http requests
    # @return [RestClient] you can set on class creation passing it on the options
    # @private
    def rest
      @rest ||= RestClient.new ENDPOINT[type], lgn: login, pwd: password
    end

    # Processes and returns all good numbers in a string
    # @param [Array<String>]
    # @return [String]
    # @raise [LocaSMS::Exception] if bad numbers were given
    # @private
    def numbers(*mobiles)
      numbers = Numbers.new mobiles
      return numbers.to_s unless numbers.bad?

      raise Exception("Bad numbers were given: #{numbers.bad.join(',')}")
    end
  end
end
