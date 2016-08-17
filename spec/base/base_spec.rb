require 'spec_helper'

 
describe port(22) do
  it { should be_listening }
end

describe port(22) do
  it { should be_listening }
end

describe file('/etc/hosts') do
  it { should contain '192.168.0.119  postgresql1.vmtest.local  postgresql1' }
  it { should contain '192.168.0.120  postgresql2.vmtest.local  postgresql2' }
  it { should contain '192.168.0.118  elastic.vmtest.local      elastic' }
  it { should contain '192.168.0.117  jenkins.vmtest.local      jenkins' }
end

