require 'spec_helper'

describe 'zabbix共通テスト1' do
  describe package('httpd'), :if => os[:family] == 'redhat' do
    it { should be_installed }
  end
end

describe 'zabbix共通テスト2' do
  describe package('apache2'), :if => os[:family] == 'ubuntu' do
    it { should be_installed }
  end
end

describe 'zabbix共通テスト3' do
  describe service('httpd'), :if => os[:family] == 'redhat' do
    it { should be_enabled }
    it { should be_running }
  end
end

describe 'zabbix共通テスト4' do
  describe service('apache2'), :if => os[:family] == 'ubuntu' do
    it { should be_enabled }
    it { should be_running }
  end
end

describe 'zabbix共通テスト5' do
  describe service('org.apache.httpd'), :if => os[:family] == 'darwin' do
    it { should be_enabled }
    it { should be_running }
  end
end

describe 'zabbix共通テスト6' do
  describe port(80) do
    it { should be_listening }
  end
end

