# frozen_string_literal: true

require 'spec_helper'

describe LocaSMS::Client do # rubocop:disable RSpec/FilePath
  subject(:client) { described_class.new :login, :password, rest_client: rest_client, callback: nil }

  let(:rest_client) { double :rest_client }

  describe '::ENDPOINT' do
    let(:domain) { described_class::DOMAIN }

    context 'when default' do
      it 'returns the default URL' do
        endpoint = described_class::ENDPOINT[client.type]
        expect(endpoint).to eq("http://#{domain}/painel/api.ashx")
      end
    end

    context 'when shortcode' do
      subject(:client) { described_class.new :login, :password, type: :shortcode }

      it 'returns the short code URL' do
        endpoint = described_class::ENDPOINT[client.type]
        expect(endpoint).to eq("http://#{domain}/shortcode/api.ashx")
      end
    end
  end

  describe '.initialize' do
    it { expect(client.login).to be(:login) }
    it { expect(client.password).to be(:password) }
  end

  describe '#deliver' do
    it 'sends SMS' do
      expect(rest_client).to receive(:get)
        .once
        .with(:sendsms, msg: 'given message', numbers: '11988889991,11988889992,11988889993', url_callback: nil)
        .and_return({})

      client.deliver 'given message', '11988889991', '11988889992', '11988889993'
    end

    context 'when receive an error' do
      let(:wrong_deliver) { -> { client.deliver('given message', '1', '2', '3') } }

      it { expect(wrong_deliver).to raise_error(LocaSMS::Exception) }

      it 'does not send SMS' do
        expect(rest_client).to receive(:get).never

        wrong_deliver
      end
    end

    context 'with callback option' do
      context 'when callback given as arg to #deliver' do
        it 'uses specific callback' do
          expect(rest_client).to receive(:get)
            .once
            .with(:sendsms, msg: 'given message', numbers: '11988889991,11988889992,11988889993', url_callback: 'something')
            .and_return({})

          client.deliver 'given message', '11988889991', '11988889992', '11988889993', url_callback: 'something'
        end
      end

      it 'uses default callback' do
        client = described_class.new :login, :password, rest_client: rest_client, url_callback: 'default'

        expect(rest_client).to receive(:get)
          .once
          .with(:sendsms, msg: 'given message', numbers: '11988889991,11988889992,11988889993', url_callback: 'default')
          .and_return({})

        client.deliver 'given message', '11988889991', '11988889992', '11988889993'
      end
    end
  end

  describe '#deliver_at' do
    it 'sends SMS' do
      allow(LocaSMS::Helpers::DateTimeHelper).to receive(:split)
        .once
        .with(:datetime)
        .and_return(%w[date time])

      expect(rest_client).to receive(:get)
        .once
        .with(:sendsms, msg: 'given message', numbers: '11988889991,11988889992,11988889993', jobdate: 'date', jobtime: 'time', url_callback: nil)
        .and_return({})

      client.deliver_at 'given message', :datetime, '11988889991', '11988889992', '11988889993'
    end

    context 'when receive an error' do
      let(:wrong_deliver_at) { -> { client.deliver_at('given message', :datetime, '1', '2', '3') } }

      before do
        allow(LocaSMS::Helpers::DateTimeHelper).to receive(:split)
          .once
          .with(:datetime)
          .and_return(%w[date time])
      end

      it { expect(wrong_deliver_at).to raise_error(LocaSMS::Exception) }

      it 'does not send SMS' do
        expect(rest_client).not_to receive(:get)

        wrong_deliver_at
      end
    end

    context 'with callback option' do
      context 'when callback given as arg to #deliver' do
        it 'uses specific callback' do
          allow(LocaSMS::Helpers::DateTimeHelper).to receive(:split)
            .once
            .with(:datetime)
            .and_return(%w[date time])

          expect(rest_client).to receive(:get)
            .once
            .with(:sendsms,
                  msg: 'given message',
                  numbers: '11988889991,11988889992,11988889993',
                  jobdate: 'date',
                  jobtime: 'time',
                  url_callback: 'something')
            .and_return({})

          client.deliver_at 'given message', :datetime, '11988889991', '11988889992', '11988889993', url_callback: 'something'
        end
      end

      it 'uses default callback' do
        client = described_class.new :login, :password, rest_client: rest_client, url_callback: 'default'

        allow(client).to receive(:numbers)
          .once
          .with(%i[a b c])
          .and_return('XXX')

        allow(LocaSMS::Helpers::DateTimeHelper).to receive(:split)
          .once
          .with(:datetime)
          .and_return(%w[date time])

        expect(rest_client).to receive(:get)
          .once
          .with(:sendsms,
                msg: 'given message',
                numbers: 'XXX',
                jobdate: 'date',
                jobtime: 'time',
                url_callback: 'default')
          .and_return({})

        client.deliver_at 'given message', :datetime, :a, :b, :c
      end
    end
  end

  describe '#balance' do
    it 'checks param assignment' do
      expect(rest_client).to receive(:get)
        .once
        .with(:getbalance)
        .and_return({})

      client.balance
    end
  end

  context 'when receive all campaign based methods' do
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

      client.send method, '12345'
    end

    it { check_for :campaign_status  }
    it { check_for :campaign_hold    }
    it { check_for :campaign_release }

    it 'has tests to cover campaign_status csv result'
  end
end
