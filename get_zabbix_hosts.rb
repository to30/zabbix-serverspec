#!/bin/env ruby

require 'net/http'
require 'json'
require 'optparse'

options = ARGV.getopts("", "url:http://172.31.2.116/zabbix/api_jsonrpc.php", "username:Admin", "password:zabbix")
ZABBIX_URL = options["url"]
ZABBIX_USER = options["username"]
ZABBIX_PASSWORD = options["password"]

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
  h["interfaces"].each do |interface|
    if interface["useip"] == "1" then
      host = {:name => interface["ip"]}
    else
      host = {:name => interface["dns"]}
    end
    break
  end
  groups = get_hostgroup_list(api_connection, h["groups"].map!{|group| group.values}.flatten)
  group_names = groups["result"].map {|group| group["name"]}
  host[:roles] = group_names

  result << host
end

puts JSON.dump(result)

