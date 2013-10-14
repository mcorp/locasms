module LocaSMS

  class Numbers
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
        .map{|number| number.gsub(/[^0-9a-zA-Z]/, '') }
        .delete_if{|number| number.empty? }
    end

    # Validates if a mobile's number has only digits
    # @param [String] number given number to be validated
    # @return [TrueClass, FalseClass] true if the number is valid
    def number_valid?(number)
      return false if number.nil? or number =~ /[^0-9a-zA-Z]/
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
      normalize(numbers).reduce({good: [], bad: []}) do |hash, number|
        bucket = number_valid?(number) ? :good : :bad
        hash[bucket] << number
        hash
      end
    end
  end

end