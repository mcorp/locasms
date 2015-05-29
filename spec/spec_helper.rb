require 'rubygems'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

# require 'coveralls'
# require 'simplecov'

# SimpleCov.start

require 'locasms'
require 'rspec'
require 'time'
require 'timecop'
Timecop.safe_mode = true

RSpec.configure do |config|
  # see spec.opts
end