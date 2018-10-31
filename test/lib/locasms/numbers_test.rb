require 'test_helper'

module LocaSMS
  class NumbersTest < ActiveSupport::TestCase
    def test_initialize__instantiage_correctly
      LocaSMS::Numbers.any_instance
        .expects(:evaluate)
        .once
        .with([:numbers])
        .returns({good: [1, 3], bad: [2, 4]})

      number = LocaSMS::Numbers.new :numbers

      assert_equal [1, 3], number.good
      assert_equal [2, 4], number.bad
    end

    def test_normalize
      number = LocaSMS::Numbers.new :numbers

      assert_equal %w(551188889999), number.normalize('+55 (11) 8888-9999')
      assert_equal %w(55 11 22),number.normalize('55', ['11', '22'])
      assert_equal %w(55 ZZ 22),number.normalize(['55', 'ZZ', '22'])
      assert_equal %w(55 44 33 ZZ 22 11),number.normalize('55,44,33', ['ZZ', '22,11'])
      assert_equal %w(55 11 22),number.normalize(55, [11, 22])

      assert_equal ['Z'], number.normalize('Z')
      assert_equal [], number.normalize(nil)
    end

    def test_valid_number
      number = LocaSMS::Numbers.new :numbers

      refute number.valid_number?('+55 (11) 8888-9999')
      refute number.valid_number?('88889999')
      refute number.valid_number?('988889999')
      refute number.valid_number?('ABC')
      refute number.valid_number?('')
      refute number.valid_number?(nil)

      assert number.valid_number?('1188889999')
      assert number.valid_number?('11988889999')
    end

    def test_evaluate
      number = LocaSMS::Numbers.new :numbers

      number.expects(:normalize).once.with([:numbers]).returns([:good, :bad])
      number.expects(:valid_number?).once.with(:good).returns(true)
      number.expects(:valid_number?).once.with(:bad).returns(false)

      expectation = { good: [:good], bad: [:bad] }
      assert_equal expectation, number.evaluate(:numbers)
    end

    def test_bad__empty_numbers
      number = LocaSMS::Numbers.new :numbers

      number.expects(:bad).once.returns([])

      refute number.bad?
    end

    def test_bad__short_numbers
      number = LocaSMS::Numbers.new :numbers

      number.expects(:bad).once.returns([1])

      assert number.bad?
    end

    def test_to_s__empty_string
      number = LocaSMS::Numbers.new :numbers

      assert_equal '', number.to_s
    end

    def test_to_s__good_numbers
      number = LocaSMS::Numbers.new :numbers

      number.expects(:good).once.returns([1, 2, 3, 4])

      assert_equal '1,2,3,4', number.to_s
    end
  end
end
