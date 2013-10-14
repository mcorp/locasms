require 'spec_helper'

describe LocaSMS::Helpers::NumbersHelper do
  subject { LocaSMS::Helpers::NumbersHelper }

  describe '.clear' do
    it{ subject.clear('+55 (11) 8888-9999').should == %w(551188889999) }
    it{ subject.clear('55', ['11', '22']).should == %w(55 11 22) }
    it{ subject.clear(['55', 'ZZ', '22']).should == %w(55 22) }
    it{ subject.clear('55,44,33', ['ZZ', '22,11']).should == %w(55 44 33 22 11) }
    it{ subject.clear(55, [11, 22]).should == %w(55 11 22) }
    it{ subject.clear('Z').should == [] }
    it{ subject.clear(nil).should == [] }
  end

  describe '#clear' do
    it 'Should call the class method' do
      subject.should_receive(:clear)
        .once
        .with([:numbers])

      subject.new.clear :numbers
    end
  end

end