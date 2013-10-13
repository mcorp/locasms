require 'spec_helper'

describe LocaSMS::Helpers::DateTimeHelper do
  subject { LocaSMS::Helpers::DateTimeHelper }

  describe '#parse' do
    it 'Should call the class method' do
      subject.should_receive(:parse)
        .once
        .with(:value)

      subject.new.parse(:value)
    end
  end

  describe '#split' do
    it 'Should call the class method' do
      subject.should_receive(:split)
        .once
        .with(:value)

      subject.new.split(:value)
    end
  end

  describe '.parse' do
    let(:expected) { Time.parse '1977-03-14 14:12:00' }

    def try_for(value)
      subject.parse(value) == expected
    end

    it { try_for DateTime.parse('1977-03-14 14:12:00') }
    it { try_for Time.parse('1977-03-14 14:12:00')     }
    it { try_for '1977-03-14 14:12:00'                 }
    it { try_for 227207520                             }
  end

  describe '.split' do
    it 'Should break a date into date and time' do
      subject.should_receive(:parse)
        .once
        .with(:datetime)
        .and_return(Time.parse('1977-03-14 14:12:00'))

      subject.split(:datetime).should == %w(14/03/1977 14:12)
    end
  end

end