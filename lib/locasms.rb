# frozen_string_literal: true

require 'locasms/version'

autoload :CSV,       'csv'
autoload :MultiJson, 'multi_json'

# Module to encapsulate implementation
module LocaSMS
  autoload :Client,           'locasms/client'
  autoload :Exception,        'locasms/exception'
  autoload :InvalidLogin,     'locasms/exception'
  autoload :InvalidOperation, 'locasms/exception'
  autoload :Numbers,          'locasms/numbers'
  autoload :RestClient,       'locasms/rest_client'

  # Module to encapsulate helpers
  module Helpers
    autoload :DateTimeHelper, 'locasms/helpers/date_time_helper'
  end
end
