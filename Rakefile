require 'rake'
require 'rspec/core/rake_task'
require 'json'
require 'net/http'

ZABBIX_URL = "http://192.168.0.162/zabbix/api_jsonrpc.php"
ZABBIX_USER = "Admin"
ZABBIX_PASSWORD = "zabbix"

ZABBIX_URI = URI.parse(ZABBIX_URL)
ZABBIX_API_HEADER = {'Content-Type' =>'application/json-rpc'}
API_REQUEST_BASE = Net::HTTP::Post.new(ZABBIX_URI.request_uri, initheader = ZABBIX_API_HEADER)
api_connection = nil
# api_connection is user.login returned value.
# {"jsonrpc"=>"2.0", "result"=>"099adde3cea983cece7c0f03195791eb", "id"=>1}


def login
  params = {user: ZABBIX_USER, password: ZABBIX_PASSWORD}

  API_REQUEST_BASE.body = {method: "user.login", auth: nil, params: params, id: 1, jsonrpc: "2.0"}.to_json

  return api_access(ZABBIX_URI, API_REQUEST_BASE)
end

def api_access(uri, request)
  response = nil

  http = Net::HTTP.new(uri.host, uri.port)
  http.start do |h|
    response = h.request(request)
  end
  return JSON.parse(response.body)
end

def get_host_list(api_connection)
  params = {output: "extend", selectGroups: "true", selectInterfaces: "extend"}

  API_REQUEST_BASE.body = {method: "host.get", auth: api_connection["result"], params: params, id: 2, jsonrpc: "2.0"}.to_json

  return api_access(ZABBIX_URI, API_REQUEST_BASE)
end

def get_hostgroup_list(api_connection, hostgroup_ids)
  params = {output: "extend", groupids: hostgroup_ids}

  API_REQUEST_BASE.body = {method: "hostgroup.get", auth: api_connection["result"], params: params, id: 3, jsonrpc: "2.0"}.to_json

  return api_access(ZABBIX_URI, API_REQUEST_BASE)
end

## main ##
result = []

api_connection = login()
hosts = get_host_list(api_connection)


hosts["result"].each do |h|
  host = {}
  h.each{|i|
    host = {:name => h["host"]}
    break
  }
  groups = get_hostgroup_list(api_connection, h["groups"].map!{|group| group.values}.flatten)
  group_names = groups["result"].map {|group| group["name"]}
  host[:roles] = group_names

  result << host
end

hosts = JSON.dump(result)
#ファイルへ出力
out_file = open("hosts.json","w")
out_file.puts(hosts)
out_file.close
task :spec    => 'spec:all'
task :default => :spec

namespace :spec do
  hosts = JSON.load(File.new('hosts.json'))
  #p hosts
  task :all     => hosts.map {|h| h['name'] }
  task :default => :all

  hosts.each do |host|
    name = host['name']
    desc "Run serverspec tests to #{name}"
    RSpec::Core::RakeTask.new(name) do |t|
      ENV['TARGET_HOST'] = name
        if ENV['CI_FLAG']
           t.rspec_opts = "--format RspecJunitFormatter --out report/serverspec/results_#{host[:name]}.xml"
        end
       #ロールに応じて適宜修正
       if host['roles'].grep(/.*app/).any? then
         #print "APPフォルダを含めた処理\n"
         t.pattern = "spec/{base,app,environment/#{host['roles'].join(',environment/')}}/**/*_spec.rb"
       elsif host['roles'].grep(/.*web/).any? then
         #print "WEBフォルダを含めた処理\n"
         t.pattern = "spec/{base,web,environment/#{host['roles'].join(',environment/')}}/**/*_spec.rb"
       elsif host['roles'].grep(/.*rc4/).any? then
         #print "WEBフォルダを含めた処理\n"
         t.pattern = "spec/{base,web,environment/#{host['roles'].join(',environment/')}}/**/*_spec.rb"
       else
         print "テストの用意されていないロール\n"
         exit
       end
    end
  end
end
