# frozen_string_literal: true

require 'spec_helper'

describe LocaSMS::Numbers do # rubocop:disable RSpec/FilePath
  subject(:number_sanitizer) { described_class.new }

  describe '#normalize' do
    it do
      expect(number_sanitizer.normalize('+55 (11) 8888-9999')).to(
        eq(%w[551188889999])
      )
    end

    it do
      expect(number_sanitizer.normalize('55', %w[11 22])).to(
        eq(%w[55 11 22])
      )
    end

    it do
      expect(number_sanitizer.normalize(%w[55 ZZ 22])).to(
        eq(%w[55 ZZ 22])
      )
    end

    it do
      expect(number_sanitizer.normalize('55,44,33', ['ZZ', '22,11'])).to(
        eq(%w[55 44 33 ZZ 22 11])
      )
    end

    it do
      expect(number_sanitizer.normalize(55, [11, 22])).to(
        eq(%w[55 11 22])
      )
    end

    it { expect(number_sanitizer.normalize('Z')).to eq(['Z']) }
    it { expect(number_sanitizer.normalize(nil)).to eq([]) }
  end

  describe '#valid_number?' do
    it { is_expected.not_to be_valid_number('+55 (11) 8888-9999') }
    it { is_expected.not_to be_valid_number('88889999') }
    it { is_expected.not_to be_valid_number('988889999') }
    it { is_expected.not_to be_valid_number('ABC') }
    it { is_expected.not_to be_valid_number('') }
    it { is_expected.not_to be_valid_number(nil) }

    it { is_expected.to be_valid_number('1188889999') }
    it { is_expected.to be_valid_number('11988889999') }
  end

  describe '#evaluate' do
    it 'separates numbers in good and bad' do
      allow(number_sanitizer).to receive(:normalize)
        .once
        .with([:numbers])
        .and_return(%i[good bad])
      allow(number_sanitizer).to receive(:valid_number?)
        .once
        .with(:good)
        .and_return(true)
      allow(number_sanitizer).to receive(:valid_number?)
        .once
        .with(:bad)
        .and_return(false)
      expect(number_sanitizer.evaluate(:numbers)).to(
        eq(good: [:good], bad: [:bad])
      )
    end
  end

  describe '#bad?' do
    it 'when bad is empty' do
      allow(number_sanitizer).to receive(:bad).once.and_return([])
      expect(number_sanitizer).not_to be_bad
    end

    it 'when bad has items' do
      allow(number_sanitizer).to receive(:bad).once.and_return([1])
      expect(number_sanitizer).to be_bad
    end
  end

  describe '#to_s' do
    it 'returns and empty string' do
      expect(number_sanitizer.to_s).to eq('')
    end

    it 'returns all good numbers in a string comma separated' do
      allow(number_sanitizer).to receive(:good)
        .once
        .and_return([1, 2, 3, 4])
      expect(number_sanitizer.to_s).to eq('1,2,3,4')
    end
  end
end
