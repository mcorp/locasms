# frozen_string_literal: true

require 'spec_helper'

describe LocaSMS::Helpers::DateTimeHelper do # rubocop:disable RSpec/FilePath
  subject(:helper) { described_class }

  describe '.parse' do
    subject { described_class.parse(value) }

    let(:expected) { Time.parse '1977-03-14 14:12:00' }

    context 'when is a date time' do
      let(:value) { DateTime.parse '1977-03-14 14:12:00' }

      it { is_expected.to eq expected }
    end

    context 'when is a time' do
      let(:value) { Time.parse '1977-03-14 14:12:00' }

      it { is_expected.to eq expected }
    end

    context 'when is a string' do
      let(:value) { '1977-03-14 14:12:00' }

      it { is_expected.to eq expected }
    end

    context 'when is a number' do
      let(:value) { 227_196_720 }

      it { is_expected.to eq expected }
    end
  end

  describe '.split' do
    it 'breaks a date into date and time' do
      expect(helper.split('1977-03-14 14:12:00')).to eq(%w[14/03/1977 14:12])
    end
  end
end
