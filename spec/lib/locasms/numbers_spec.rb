require 'spec_helper'

describe LocaSMS::Numbers do
  subject { LocaSMS::Numbers.new }

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

end