# frozen_string_literal: true

require 'spec_helper'

describe LocaSMS::Numbers do
  subject { LocaSMS::Numbers.new }

  describe '.initialize' do
    subject do
      expect_any_instance_of(LocaSMS::Numbers)
        .to receive(:evaluate)
        .once
        .with([:numbers])
        .and_return(good: [1, 3], bad: [2, 4])
      LocaSMS::Numbers.new :numbers
    end

    it { expect(subject.good).to eq([1, 3]) }
    it { expect(subject.bad).to eq([2, 4]) }
  end

  describe '#normalize' do
    it do
      expect(subject.normalize('+55 (11) 8888-9999')).to(
        eq(%w[551188889999])
      )
    end
    it do
      expect(subject.normalize('55', %w[11 22])).to(
        eq(%w[55 11 22])
      )
    end
    it do
      expect(subject.normalize(%w[55 ZZ 22])).to(
        eq(%w[55 ZZ 22])
      )
    end
    it do
      expect(subject.normalize('55,44,33', ['ZZ', '22,11'])).to(
        eq(%w[55 44 33 ZZ 22 11])
      )
    end
    it do
      expect(subject.normalize(55, [11, 22])).to(
        eq(%w[55 11 22])
      )
    end
    it { expect(subject.normalize('Z')).to eq(['Z']) }
    it { expect(subject.normalize(nil)).to eq([]) }
  end

  describe '#valid_number?' do
    it { expect(subject.valid_number?('+55 (11) 8888-9999')).to be_falsey }
    it { expect(subject.valid_number?('88889999')).to be_falsey }
    it { expect(subject.valid_number?('988889999')).to be_falsey }
    it { expect(subject.valid_number?('ABC')).to be_falsey }
    it { expect(subject.valid_number?('')).to be_falsey }
    it { expect(subject.valid_number?(nil)).to be_falsey }

    it { expect(subject.valid_number?('1188889999')).to be_truthy }
    it { expect(subject.valid_number?('11988889999')).to be_truthy }
  end

  describe '#evaluate' do
    it 'Should separate numbers in good and bad' do
      expect(subject).to receive(:normalize)
        .once
        .with([:numbers])
        .and_return(%i[good bad])
      expect(subject).to receive(:valid_number?)
        .once
        .with(:good)
        .and_return(true)
      expect(subject).to receive(:valid_number?)
        .once
        .with(:bad)
        .and_return(false)
      expect(subject.evaluate(:numbers)).to(
        eq(good: [:good], bad: [:bad])
      )
    end
  end

  describe '#bad?' do
    it do
      expect(subject).to receive(:bad).once.and_return([ ])
      expect(subject.bad?).to be_falsey
    end
    it do
      expect(subject).to receive(:bad).once.and_return([1])
      expect(subject.bad?).to be_truthy
    end
  end

  describe '#to_s' do
    it 'Should return and empty string' do
      expect(subject.to_s).to eq('')
    end

    it 'Should return all good numbers in a string comma separated' do
      expect(subject).to receive(:good)
        .once
        .and_return([1, 2, 3, 4])
      expect(subject.to_s).to eq('1,2,3,4')
    end
  end

end
