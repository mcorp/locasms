# frozen_string_literal: true

require 'locasms'
require 'mocha/setup'
require 'shoulda'
require 'timecop'

Timecop.safe_mode = true

module ActiveSupport
  class TestCase < Minitest::Test
  end
end
