require 'spec_helper'

describe 'production-web用テスト1' do 
  describe port(22) do
    it { should be_listening }
  end
end

describe 'production-web用テスト2' do
  describe port(22) do
    it { should be_listening }
  end
end
