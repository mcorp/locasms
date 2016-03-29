require 'spec_helper'

describe LocaSMS::Client do
  let(:rest_client) { 'rest_client mock' }
  subject { LocaSMS::Client.new :login, :password, rest_client: rest_client }

  context '.ENDPOINT' do
    def test_when(moment_in_time)
      Timecop.freeze(Time.parse(moment_in_time)) do
        LocaSMS.send :remove_const, :Client
        load 'lib/locasms/client.rb'
        yield
      end
    end

    it 'prior to Jun 1st, 2015' do
      test_when('2015-05-31T23:59:59-0300') do
        expect(LocaSMS::Client::ENDPOINT).to(
          eq('http://173.44.33.18/painel/api.ashx')
        )
      end
    end

    it 'is Jun 1st, 2015' do
      test_when('2015-06-01T00:00:00-0300') do
        expect(LocaSMS::Client::ENDPOINT).to(
          eq('http://209.133.196.250/painel/api.ashx')
        )
      end
    end

    it 'after Jun 1st, 2015 and prior to March 29, 2016' do
      test_when('2016-03-28T00:00:00-0300') do
        expect(LocaSMS::Client::ENDPOINT).to(
          eq('http://209.133.196.250/painel/api.ashx')
        )
      end
    end

    it 'is March 29, 2016' do
      test_when('2016-03-29T00:00:00-0300') do
        expect(LocaSMS::Client::ENDPOINT).to(
          eq('http://54.173.24.177/painel/api.ashx')
        )
      end
    end

    it 'after March 29, 2016' do
      test_when('2017-01-01T00:00:00-0300') do
        expect(LocaSMS::Client::ENDPOINT).to(
          eq('http://54.173.24.177/painel/api.ashx')
        )
      end
    end
  end

  describe '.initialize' do
    it { expect(subject.login).to be(:login) }
    it { expect(subject.password).to be(:password) }
  end

  describe '#deliver' do
    it 'Should send SMS' do
      expect(subject).to receive(:numbers)
        .once
        .with([:a, :b, :c])
        .and_return('XXX')

      expect(rest_client).to receive(:get)
        .once
        .with(:sendsms, msg: 'given message', numbers:'XXX')
        .and_return({})

      subject.deliver 'given message', :a, :b, :c
    end

    it 'Should not send SMS' do
      expect(subject).to receive(:numbers)
        .once
        .with([:a, :b, :c])
        .and_raise(LocaSMS::Exception)

      expect(rest_client).to receive(:get).never

      expect { subject.deliver('given message', :a, :b, :c) }.to raise_error(LocaSMS::Exception)
    end
  end

  describe '#deliver_at' do
    it 'Should send SMS' do
      expect(subject).to receive(:numbers)
        .once
        .with([:a, :b, :c])
        .and_return('XXX')

      expect(LocaSMS::Helpers::DateTimeHelper).to receive(:split)
        .once
        .with(:datetime)
        .and_return(%w[date time])

      expect(rest_client).to receive(:get)
        .once
        .with(:sendsms, msg: 'given message', numbers:'XXX', jobdate: 'date', jobtime: 'time')
        .and_return({})

      subject.deliver_at 'given message', :datetime, :a, :b, :c
    end

    it 'Should not send SMS' do
      expect(subject).to receive(:numbers)
        .once
        .with([:a, :b, :c])
        .and_raise(LocaSMS::Exception)

      expect(LocaSMS::Helpers::DateTimeHelper).to receive(:split)
        .once
        .with(:datetime)
        .and_return(%w[date time])

      expect(rest_client).to receive(:get).never

      expect { subject.deliver_at('given message', :datetime, :a, :b, :c) }.to raise_error(LocaSMS::Exception)
    end
  end

  describe '#balance' do
    it 'Should check param assignment' do
      expect(rest_client).to receive(:get)
        .once
        .with(:getbalance)
        .and_return({})

      subject.balance
    end
  end

  context 'Testing all campaign based methods' do
    def check_for(method)
      rest_method = {
        campaign_status: :getstatus,
        campaign_hold: :holdsms,
        campaign_release: :releasesms
      }[method]

      expect(rest_client).to receive(:get)
        .once
        .with(rest_method, id: '12345')
        .and_return({})

      subject.send method, '12345'
    end

    it{ check_for :campaign_status  }
    it{ check_for :campaign_hold    }
    it{ check_for :campaign_release }

    it 'Should have tests to cover campaign_status csv result'
  end

end
