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

end