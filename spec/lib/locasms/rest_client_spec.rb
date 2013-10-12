require 'spec_helper'

describe LocaSMS::RestClient do

  describe '.initialize' do
    context 'When giving proper initialization parameters' do
      subject { LocaSMS::RestClient.new :url, :params }
      it { subject.base_url.should be(:url) }
      it { subject.base_params.should be(:params) }
    end
  end

  describe '#get' do
    it 'Is missing tests for get'
  end

  describe '#params_for' do
    subject { LocaSMS::RestClient.new :url, { b1: 'X' } }

    it{ subject.params_for(:action).should == {action: :action, b1: 'X'} }
    it{ subject.params_for(:action, p1: 10).should == {action: :action, b1: 'X', p1: 10} }
  end

end