require 'spec_helper'

describe server(:rc4) do
  describe http('http://rc4:8080/jenkins') do
    before do
      current_server.ssh_exec("sudo /sbin/service glassfish restart;sleep 300;")
    end
    it "responds content including 'jenkins'" do
      expect(response.body).to include('jenkins')
    end

    #it "responds as 'text/html; charset=UTF-8'" do
    #  expect(response.headers['content-type']).to eq("text/html; charset=UTF-8")
    #end
  end
end

describe server(:rc4) do
  let(:time) { Time.now }
  before do
    current_server.ssh_exec "echo 'Hello' > /tmp/test-#{time.to_i}"
  end
  it "executes a command on the current server" do
    result = current_server.ssh_exec("cat /tmp/test-#{time.to_i}")
    expect(result.chomp).to eq('Hello')
  end
end

