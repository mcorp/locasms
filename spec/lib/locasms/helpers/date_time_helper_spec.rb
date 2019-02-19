require 'spec_helper'

describe LocaSMS::Helpers::DateTimeHelper do
  subject { LocaSMS::Helpers::DateTimeHelper }

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
end
