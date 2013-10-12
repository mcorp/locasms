require 'spec_helper'

describe LocaSMS::Client do
  let(:rest_client) { 'rest_client mock' }
  subject { LocaSMS::Client.new :login, :password, rest_client: rest_client }

  describe '.initialize' do
    it { subject.login.should be(:login) }
    it { subject.password.should be(:password) }
  end

  describe '#deliver' do
    before(:each) do
      rest_client.should_receive(:get)
        .once
        .with(:sendsms, msg: 'given message', numbers:'1188882222,5577770000')
    end

    it{ subject.deliver 'given message', '1188882222,5577770000'      }
    it{ subject.deliver 'given message', %w(1188882222 5577770000)    }
    it{ subject.deliver 'given message', '1188882222', '5577770000'   }
    it{ subject.deliver 'given message', ['1188882222', '5577770000'] }
  end

  it '#deliver_at'

  describe '#balance' do
    it 'Should check param assignment' do
      rest_client.should_receive(:get)
        .once
        .with(:getbalance)

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

      subject.send method, '12345'
    end

    it{ check_for :campaign_status  }
    it{ check_for :campaign_hold    }
    it{ check_for :campaign_release }
  end

end