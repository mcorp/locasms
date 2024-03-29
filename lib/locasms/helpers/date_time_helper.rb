# frozen_string_literal: true

module LocaSMS
  module Helpers
    # Helper class to handle with time parsing
    class DateTimeHelper
      # Parse a value into a time
      # @param [Fixnum,String,DateTime,Time,#to_time] date
      # @result [Time] return a parsed time
      #
      # @example
      #
      #     DateTimeHelper.parse '1977-03-14 14:12:00'
      #     # => 1977-03-14 14:12:00 -0300
      #
      #     DateTimeHelper.split 227207520
      #     # => 1977-03-14 14:12:00 -0300
      #
      def self.parse(date)
        date = Time.at(date)    if date.is_a? Integer
        date = Time.parse(date) if date.is_a? String
        date = date.to_time     if date.respond_to? :to_time
        date
      end

      # Breaks a given date in date and time
      # @param [Fixnum,String,DateTime,Time,#to_time] date
      # @result [Array<String>] an array containing respectively DD/MM/YYYY and HH:MM
      #
      # @example
      #
      #     DateTimeHelper.split Time.now
      #     # => ['14/03/1977', '14:12']
      #
      #     DateTimeHelper.split 227207520
      #     # => ['14/03/1977', '14:12']
      #
      def self.split(date)
        parse(date).strftime('%d/%m/%Y %H:%M').split
      end
    end
  end
end
