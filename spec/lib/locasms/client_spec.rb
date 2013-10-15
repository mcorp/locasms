require 'spec_helper'

describe LocaSMS::Client do
  let(:rest_client) { 'rest_client mock' }
  subject { LocaSMS::Client.new :login, :password, rest_client: rest_client }

  describe '.initialize' do
    it { subject.login.should be(:login) }
    it { subject.password.should be(:password) }
  end

  describe '#deliver' do
    it 'Should send SMS' do
      subject.should_receive(:numbers)
        .once
        .with([:a, :b, :c])
        .and_return('XXX')

      rest_client.should_receive(:get)
        .once
        .with(:sendsms, msg: 'given message', numbers:'XXX')
        .and_return({})

      subject.deliver 'given message', :a, :b, :c
    end

    it 'Should not send SMS' do
      subject.should_receive(:numbers)
        .once
        .with([:a, :b, :c])
        .and_raise(LocaSMS::Exception)

      rest_client.should_receive(:get).never

      lambda{ subject.deliver('given message', :a, :b, :c) }.should raise_error(LocaSMS::Exception)
    end
  end

  describe '#deliver_at' do
    it 'Should send SMS' do
      subject.should_receive(:numbers)
        .once
        .with([:a, :b, :c])
        .and_return('XXX')

      LocaSMS::Helpers::DateTimeHelper.should_receive(:split)
        .once
        .with(:datetime)
        .and_return(%w[date time])

      rest_client.should_receive(:get)
        .once
        .with(:sendsms, msg: 'given message', numbers:'XXX', jobdate: 'date', jobtime: 'time')
        .and_return({})

      subject.deliver_at 'given message', :datetime, :a, :b, :c
    end

    it 'Should not send SMS' do
      subject.should_receive(:numbers)
        .once
        .with([:a, :b, :c])
        .and_raise(LocaSMS::Exception)

      LocaSMS::Helpers::DateTimeHelper.should_receive(:split)
        .once
        .with(:datetime)
        .and_return(%w[date time])

      rest_client.should_receive(:get).never

      lambda{ subject.deliver_at('given message', :datetime, :a, :b, :c) }.should raise_error(LocaSMS::Exception)
    end
  end

  describe '#balance' do
    it 'Should check param assignment' do
      rest_client.should_receive(:get)
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

      rest_client.should_receive(:get)
        .once
        .with(rest_method, id: '12345')
        .and_return({})

      subject.send method, '12345'
    end

    it{ check_for :campaign_status  }
    it{ check_for :campaign_hold    }
    it{ check_for :campaign_release }
  end

end