# frozen_string_literal: true

require 'spec_helper'

describe LocaSMS::Helpers::DateTimeHelper do
  subject(:helper) { described_class }

  describe '#parse' do
    it 'calls the class method' do
      expect(helper).to receive(:parse)
        .once
        .with(:value)

      helper.new.parse(:value)
    end
  end

  describe '#split' do
    it 'calls the class method' do
      expect(helper).to receive(:split)
        .once
        .with(:value)

      helper.new.split(:value)
    end
  end

  describe '.parse' do
    let(:expected) { Time.parse '1977-03-14 14:12:00' }

    def try_for(value)
      helper.parse(value) == expected
    end

    it { try_for DateTime.parse('1977-03-14 14:12:00') }
    it { try_for Time.parse('1977-03-14 14:12:00') }
    it { try_for '1977-03-14 14:12:00' }
    it { try_for 227_207_520 }
  end

  describe '.split' do
    it 'breaks a date into date and time' do
      allow(helper).to receive(:parse)
        .once
        .with(:datetime)
        .and_return(Time.parse('1977-03-14 14:12:00'))

      expect(helper.split(:datetime)).to eq(%w[14/03/1977 14:12])
    end
  end
end
