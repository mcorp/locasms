# frozen_string_literal: true

module LocaSMS
  # Class that sanitizes and validates a list of mobile's numbers
  class Numbers
    attr_reader :good, :bad

    # Creates a new instance of the class, separating good and bad numbers
    # @param [Array<String>] numbers given mobile numbers
    # @see #normalize
    # @see #evaluate
    def initialize(*numbers)
      evaluated = evaluate(numbers)
      @good = evaluated[:good]
      @bad = evaluated[:bad]
    end

    # Checks if there are bad numbers
    # @return [TrueClass, FalseClass] true if there are bad numbers
    # @see #valid_number?
    def bad?
      not bad.empty?
    end

    # Clears all non digits from a mobile's number and converts into a normalized array
    # @param [Array<String>] numbers list of mobile numbers to be clean
    # @return [Array<String>] a normalized list of mobile numbers
    # @example
    #     numbers = Numbers.new
    #     numbers.normalize '+55 (41) 8888-9999'
    #     # => ['554188889999']
    #     numbers.normalize '8888-9999', '7777-0000'
    #     # => ['88889999','77770000']
    #     numbers.normalize '8888-9999,7777-0000'
    #     # => ['88889999','77770000']
    #     numbers.normalize '8888-9999', ['AA', '6666-9999', '7777-0000'], '3333-4444,555-9999'
    #     # => ['88889999','AA','66669999','77770000','33334444','5559999']
    def normalize(*numbers)
      numbers = numbers.join(',')
                       .split(',')
                       .map { |number| number.gsub(/[^0-9a-zA-Z]/, '') }
                       .delete_if(&:empty?)
    end

    # Validates if a mobile's number has only digits
    # @param [String] number given number to be validated
    # @return [TrueClass, FalseClass] true if the number is valid
    def valid_number?(number)
      return false if number.nil? || number =~(/[^0-9a-zA-Z]/)

      [10, 11].include? number.size
    end

    # Evaluates a list of numbers and separat them in two groups. The good ones
    # and the bad ones.
    # @param [Array<String>] numbers given numbers to evaluate
    # @return [Hash] containing two values. :good with the good numbers and :bad
    # for the bad ones
    # @example With only good numbers
    #     Numbers.new.evaluate('4199998888','11777770000')
    #     #=> {good: ['4199998888','11777770000'], bad: []}
    # @example With only bad numbers
    #     Numbers.new.evaluate('5551212')
    #     #=> {good: [], bad: ['5551212']}
    # @example With good and bad numbers mixed
    #     Numbers.new.evaluate('4199998888','11777770000','5551212')
    #     #=> {good: ['4199998888','11777770000'], bad: ['5551212']}
    def evaluate(*numbers)
      normalize(numbers).each_with_object({ good: [], bad: [] }) do |number, hash|
        bucket = valid_number?(number) ? :good : :bad
        hash[bucket] << number
      end
    end

    # Return all good numbers in a string comma joined
    # @return [String] all good numbers in a string comma joined
    def to_s
      (good || []).join(',')
    end
  end
end
