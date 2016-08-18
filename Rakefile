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
#  h["interfaces"].each do |interface|
#    if interface["useip"] == "1" then
#      host = {:name => interface["ip"]}
#    else
#      host = {:name => interface["dns"]}
#    end
#    break
#  end


#管理しているサーバのIPアドレスが欲しいのではなくIPアドレスが欲しいので以下に書き換え
#ZabbixのエージェントのインターフェースがDNS名ではなくIPアドレス（Zabbixサーバから見たアドレス）がデフォルトの設定
  h.each{|i|
    host = {:name => h["host"]}
    break
  }
#変更はここまで
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
#ファイル出力完了
task :spec    => 'spec:all'
task :default => :spec

namespace :spec do
  hosts = JSON.load(File.new('hosts.json'))
  p hosts
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
#ディレクトリ構成に応じてここを修正する
#対象サーバの環境とロールは判っているので"ロールとしての共通のテストディレクトリ"と"各環境毎の差異があるテストディレクトリ"
#ここで{#{host['roles'].join(',')}}に入るものを再構築する必要がある既にbaseは追加済み
#もし配列の中にwebがあったらみたいな分岐
#       print "############################\n"
#       print "#{host['roles']}\n"  #配列の表示
#       print "############################\n"
       #kekka = #{host['roles']}.grep(/[a-z]/)
       #p host['roles'].include?("staging-app")  #正規表現使用不可 true false を返すのでこっちがいい
       #kekka = host['roles'].grep(/.*app/)      #正規表現使用可
       #p host['roles'].grep(/.*app/).none?      #これは逆
       #p host['roles'].grep(/.*app/).any?        #これが正解
       #kekka = "abc"
       #p kekka
#       print "############################\n"
       if host['roles'].grep(/.*app/).any? then
         print "APPフォルダを含めた処理\n"
         t.pattern = "spec/{base,app,environment/#{host['roles'].join(',environment/')}}/**/*_spec.rb"
       elsif host['roles'].grep(/.*web/).any? then
         print "WEBフォルダを含めた処理\n"
         t.pattern = "spec/{base,web,environment/#{host['roles'].join(',environment/')}}/**/*_spec.rb"
       else
         print "テストの用意されていないロール\n"
         exit
       end
###############################################################
#       t.pattern = "spec/{base,#{host['roles'].join(',')}}/**/*_spec.rb"
    end
  end
end
