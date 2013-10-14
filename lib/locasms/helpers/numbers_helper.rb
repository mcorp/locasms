module LocaSMS
module Helpers

  class NumbersHelper
    # Clears all non digits from a mobile's number
    # @param [Array<String>] numbers list of mobile numbers to be clean
    # @return [Array<String>] a normalized list of mobile numbers
    # @example
    #     NumbersHelper.clear '+55 (41) 8888-9999'
    #     # => ['554188889999']
    #     NumbersHelper.clear '8888-9999', '7777-0000'
    #     # => ['88889999','77770000']
    #     NumbersHelper.clear '8888-9999,7777-0000'
    #     # => ['88889999','77770000']
    #     NumbersHelper.clear '8888-9999', ['AA', '6666-9999', '7777-0000'], '3333-4444,555-9999'
    #     # => ['88889999','66669999','77770000','33334444','5559999']
    def self.clear(*numbers)
      numbers = numbers.join(',')
        .split(',')
        .map{|number| number.gsub(/\D/, '') }
        .delete_if{|number| number.empty? }
    end

    # Clears all non digits from a mobile's number
    # @param [Array<String>] numbers list of mobile numbers to be clean
    # @return [Array<String>] a normalized list of mobile numbers
    # @example
    #     nr = NumbersHelper.new
    #     nr.clear '+55 (41) 8888-9999'
    #     # => ['554188889999']
    #     nr.clear '8888-9999', '7777-0000'
    #     # => ['88889999','77770000']
    #     nr.clear '8888-9999,7777-0000'
    #     # => ['88889999','77770000']
    #     nr.clear '8888-9999', ['AA', '6666-9999', '7777-0000'], '3333-4444,555-9999'
    #     # => ['88889999','66669999','77770000','33334444','5559999']
    def clear(*numbers)
      NumbersHelper.clear numbers
    end
  end

end
end