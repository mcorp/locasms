# frozen_string_literal: true

require 'spec_helper'

describe LocaSMS::Numbers do # rubocop:disable RSpec/FilePath
  subject(:number_sanitizer) { described_class.new numbers }

  let(:numbers) { '1188889999' }

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
      expect(number_sanitizer.evaluate('11988889999', 'abc')).to eq(good: ['11988889999'], bad: ['abc'])
    end
  end

  describe '#bad?' do
    subject(:number_sanitizer) { described_class.new numbers }

    context 'when bad is empty' do
      let(:numbers) { '11988889999' }

      it { expect(number_sanitizer).not_to be_bad }
    end

    context 'when bad has items' do
      let(:numbers) { 'ABC' }

      it { expect(number_sanitizer).to be_bad }
    end
  end

  describe '#to_s' do
    context 'when is empty returns empty string' do
      let(:numbers) { '' }

      it { expect(number_sanitizer.to_s).to eq('') }
    end

    context 'when all good numbers returns in a string comma separated' do
      let(:numbers) { %w[11988889991 11988889992 11988889993] }

      it { expect(number_sanitizer.to_s).to eq('11988889991,11988889992,11988889993') }
    end
  end
end
