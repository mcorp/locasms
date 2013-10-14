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
    #     # => ['88889999','66669999','77770000','33334444','5559999']
    def normalize(*numbers)
      numbers = numbers.join(',')
        .split(',')
        .map{|number| number.gsub(/[^0-9a-zA-Z]/, '') }
        .delete_if{|number| number.empty? }
    end
  end

end