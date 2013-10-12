require 'spec_helper'

describe LocaSMS::RestClient do

  describe '.initialize' do
    context 'When giving proper initialization parameters' do
      subject { LocaSMS::RestClient.new :url, :params }
      it { subject.base_url.should be(:url) }
      it { subject.base_params.should be(:params) }
    end
  end

end