require 'spec_helper'

describe 'production-appテスト1' do 
  describe port(22) do
    it { should be_listening }
  end
end

describe 'production-appテスト2' do
  describe port(22) do
    it { should be_listening }
  end
end
