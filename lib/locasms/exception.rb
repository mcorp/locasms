module LocaSMS

  # Common base exception
  class Exception < ::Exception; end

  # Raised when asked for an invalid operation
  # @see https://github.com/mcorp/locasms/wiki/A-API-de-envio#lista-das-a%C3%A7%C3%B5es-dispon%C3%ADveis
  class InvalidOperation < Exception; end

  # Raised when the given credentials are invalid
  class InvalidLogin < Exception; end

end