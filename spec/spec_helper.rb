require 'serverspec'
require 'net/ssh'
require 'infrataster/rspec'

set :backend, :ssh
set :request_pty, true



if ENV['ASK_SUDO_PASSWORD']
  begin
    require 'highline/import'
  rescue LoadError
    fail "highline is not available. Try installing it."
  end
  set :sudo_password, ask("Enter sudo password: ") { |q| q.echo = false }
else
  set :sudo_password, ENV['SUDO_PASSWORD']
end

host = ENV['TARGET_HOST']

#options[:keys] = ENV['KEY'];
#options = Net::SSH::Config.for(host)
options = {
  paranoid: false,
  user_known_hosts_file: '/dev/null',
  keys: '/tmp/id_rsa'
}
Net::SSH::Config.for(host)

options[:user] = ENV['USER'] ||= Etc.getlogin
#options[:user] ||= Etc.getlogin

set :host,        options[:host_name] || host
set :ssh_options, options

# Disable sudo
# set :disable_sudo, true


# Set environment variables
# set :env, :LANG => 'C', :LC_MESSAGES => 'C'

# Set PATH
# set :path, '/sbin:/usr/local/sbin:$PATH'


Infrataster::Server.define(
  :rc4,
  '192.168.0.0/24',
  ssh: {host_name: host, user: 'ansible', keys: '/tmp/id_rsa'}
)


RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end







