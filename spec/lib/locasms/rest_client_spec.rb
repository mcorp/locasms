# frozen_string_literal: true

require 'spec_helper'

describe LocaSMS::RestClient do
  let(:callback) { 'http://example.com/callback' }
  let(:params) { { lgn: 'LOGIN', pwd: 'PASSWORD', url_callback: callback } }

  describe '.initialize' do
    context 'When giving proper initialization parameters' do
      subject { LocaSMS::RestClient.new :url, :params }
      it { expect(subject.base_url).to be(:url) }
      it { expect(subject.base_params).to be(:params) }
    end
  end

  describe '#get' do
    let(:action) { 'sendsms' }
    let(:body) { '{"status":1,"data":28,"msg":null}' }
    subject { LocaSMS::RestClient.new(action, params) }

    it 'Performs get request to url with parameters' do
      expect(Net::HTTP).
        to receive(:get_response).
             and_return(OpenStruct.new(body: body))

      subject.get(action, params)
    end
  end

  describe '#params_for' do
    subject { LocaSMS::RestClient.new :url, params }

    it { expect(subject.params_for(:action)).to eq({action: :action}.merge(params)) }
    it { expect(subject.params_for(:action, p1: 10)).to eq({action: :action, p1: 10}.merge(params)) }

    context 'callback nil' do
      let(:callback) { nil }
      it 'should not be in params' do
        expect(subject.params_for(:action)).to eq({action: :action, lgn: 'LOGIN', pwd: 'PASSWORD'})
      end
    end
  end

  describe '#parse_response' do
    subject { LocaSMS::RestClient.new :url, :params }

    it 'Should raise exception on invalid operation' do
      expect { subject.parse_response(:action, '0:OPERACAO INVALIDA') }.to raise_error(LocaSMS::InvalidOperation)
    end

    it 'Should raise exception on a failed response' do
      expect { subject.parse_response(:action, '{"status":0,"data":null,"msg":"FALHA EPICA"}') }.to raise_error(LocaSMS::Exception, 'FALHA EPICA')
    end

    it 'Should raise exception on a failed login attempt' do
      expect { subject.parse_response(:action, '{"status":0,"data":null,"msg":"FALHA AO REALIZAR LOGIN"}') }.to raise_error(LocaSMS::InvalidLogin)
    end

    it 'Should return the non-json value as a json' do
      expect(subject.parse_response(:action, 'non-json return')).to eq({'status' => 1, 'data' => 'non-json return', 'msg' => nil})
    end

    it 'Should return a parsed json return' do
      expect(subject.parse_response(:action, '{"status":1,"data":28,"msg":null}')).to eq({'status' => 1, 'data' => 28, 'msg' => nil})
    end
  end

end
