require "locasms/version"

autoload :JSON,       'json'
autoload :RestClient, 'rest_client'
autoload :Logger,     'logger'

module LocaSMS
  autoload :Client,     'locasms/client'
  autoload :RestClient, 'locasms/rest_client'
end
