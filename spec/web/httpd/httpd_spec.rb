require 'spec_helper'

describe 'web共通httpdの下用テスト1' do 
  describe port(22) do
    it { should be_listening }
  end
end

describe 'web共通httpdの下用テスト2' do
  describe port(22) do
    it { should be_listening }
  end
end
