module LocaSMS

  # Common base exception
  class Exception < ::Exception
    attr_reader :raw, :action

    def initialize(data = {})
      @raw    = data[:raw]
      @action = data[:data]

      super data[:message] || default_message
    end

  private

    def default_message
      nil
    end
  end

  # Raised when asked for an invalid operation
  # @see https://github.com/mcorp/locasms/wiki/A-API-de-envio#lista-das-a%C3%A7%C3%B5es-dispon%C3%ADveis
  class InvalidOperation < Exception
    def default_message
      'Invalid Operation'
    end
  end

  # Raised when the given credentials are invalid
  class InvalidLogin < Exception
    def default_message
      'Invalid Login'
    end
  end

end