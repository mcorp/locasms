require 'spec_helper'

describe LocaSMS::Client do

  describe '.initialize' do
    subject { LocaSMS::Client.new :login, :password }
    it { subject.login.should be(:login) }
    it { subject.password.should be(:password) }
  end

end