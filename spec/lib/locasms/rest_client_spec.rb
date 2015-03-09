require 'spec_helper'

describe LocaSMS::RestClient do
  describe '.initialize' do
    context 'When giving proper initialization parameters' do
      subject { LocaSMS::RestClient.new :url, :params }
      it { expect(subject.base_url).to be(:url) }
      it { expect(subject.base_params).to be(:params) }
    end
  end

  describe '#get' do
    it 'Is missing tests for get'
  end

  describe '#params_for' do
    subject { LocaSMS::RestClient.new :url, { b1: 'X' } }

    it { expect(subject.params_for(:action)).to eq({action: :action, b1: 'X'}) }
    it { expect(subject.params_for(:action, p1: 10)).to eq({action: :action, b1: 'X', p1: 10}) }
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
      expect(subject.parse_response(:action, 'non-json return')).to eq({'status' => 1, 'data' => 'non-json return', "msg" => nil})
    end

    it 'Should return a parsed json return' do
      expect(subject.parse_response(:action, '{"status":1,"data":28,"msg":null}')).to eq({'status' => 1, 'data' => 28, "msg" => nil})
    end
  end

end