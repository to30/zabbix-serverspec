require 'spec_helper'

describe 'APP共通テスト1' do 
  describe port(22) do
    it { should be_listening }
  end
end

describe 'APP共通テスト2' do
  describe port(22) do
    it { should be_listening }
  end
end
