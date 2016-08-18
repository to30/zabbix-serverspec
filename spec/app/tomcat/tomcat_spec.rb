require 'spec_helper'

describe 'APP共通tomcatの下用テスト1' do 
  describe port(22) do
    it { should be_listening }
  end
end

describe 'APP共通tomcatの下用テスト2' do
  describe port(22) do
    it { should be_listening }
  end
end
