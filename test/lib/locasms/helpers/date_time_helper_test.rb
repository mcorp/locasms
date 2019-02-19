require 'test_helper'

module LocaSMS
  class DateTimeHelperTest < ActiveSupport::TestCase
    def test_instance_parse
      Helpers::DateTimeHelper.expects(:parse).once.with(:value)

      Helpers::DateTimeHelper.new.parse(:value)
    end

    def test_instance_split
      LocaSMS::Helpers::DateTimeHelper.expects(:split).once.with(:value)

      LocaSMS::Helpers::DateTimeHelper.new.split(:value)
    end

    def test_class_split
      LocaSMS::Helpers::DateTimeHelper.expects(:parse).once
        .with(:some_datetime).returns(Time.parse('1977-03-14 14:12:00'))

      assert_equal %w(14/03/1977 14:12),
        LocaSMS::Helpers::DateTimeHelper.split(:some_datetime)
    end
  end
end
