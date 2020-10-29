# frozen_string_literal: true

require 'spec_helper'

describe LocaSMS::Helpers::DateTimeHelper do # rubocop:disable RSpec/FilePath
  subject(:helper) { described_class }

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
      expect(helper.split('1977-03-14 14:12:00')).to eq(%w[14/03/1977 14:12])
    end
  end
end
