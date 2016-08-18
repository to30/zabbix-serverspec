require 'spec_helper'

describe 'production-web/httpdの下用テスト1' do 
  describe port(22) do
    it { should be_listening }
  end
end

describe 'production-web/httpdの下用テスト2' do
  describe port(22) do
    it { should be_listening }
  end
end
