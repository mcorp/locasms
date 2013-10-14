require 'spec_helper'

describe LocaSMS::Numbers do
  subject { LocaSMS::Numbers.new }

  describe '.initialize' do
    subject do
      LocaSMS::Numbers.any_instance
        .should_receive(:evaluate)
        .once
        .with([:numbers])
        .and_return({ good: [1,3], bad: [2,4] })
      LocaSMS::Numbers.new :numbers
    end

    it{ subject.good.should == [1,3] }
    it{ subject.bad.should == [2,4]  }
  end

  describe '#normalize' do
    it{ subject.normalize('+55 (11) 8888-9999').should == %w(551188889999) }
    it{ subject.normalize('55', ['11', '22']).should == %w(55 11 22) }
    it{ subject.normalize(['55', 'ZZ', '22']).should == %w(55 ZZ 22) }
    it{ subject.normalize('55,44,33', ['ZZ', '22,11']).should == %w(55 44 33 ZZ 22 11) }
    it{ subject.normalize(55, [11, 22]).should == %w(55 11 22) }
    it{ subject.normalize('Z').should == ['Z'] }
    it{ subject.normalize(nil).should == [] }
  end

  describe '#number_valid?' do
    it{ subject.number_valid?('+55 (11) 8888-9999').should be_false }
    it{ subject.number_valid?('88889999').should be_false }
    it{ subject.number_valid?('988889999').should be_false }
    it{ subject.number_valid?('ABC').should be_false }
    it{ subject.number_valid?('').should be_false }
    it{ subject.number_valid?(nil).should be_false }

    it{ subject.number_valid?('1188889999').should be_true }
    it{ subject.number_valid?('11988889999').should be_true }
  end

  describe '#evaluate' do
    it 'Should separate numbers in good and bad' do
      subject.should_receive(:normalize)
        .once
        .with([:numbers])
        .and_return([:good, :bad])
      subject.should_receive(:number_valid?)
        .once
        .with(:good)
        .and_return(true)
      subject.should_receive(:number_valid?)
        .once
        .with(:bad)
        .and_return(false)
      subject.evaluate(:numbers).should == { good: [:good], bad: [:bad] }
    end
  end

  describe '#bad?' do
    it{ subject.should_receive(:bad).once.and_return([ ]); subject.bad?.should be_false }
    it{ subject.should_receive(:bad).once.and_return([1]); subject.bad?.should be_true  }
  end

end