# Zabbixからテスト対象のホスト情報を動的に取得する

##CI_FLAG=true を付けることでテスト結果をJUnit形式で保存  
rake spec:c7red CI_FLAG=true  


[centos@ip-172-31-7-21 serverspec]$ rake -T  
[{"name"=>"zabbix", "roles"=>["Zabbix servers"]}, {"name"=>"pa1", "roles"=>["production-app"]}, {"name"=>"pa2", "roles"=>["production-app"]}, {"name"=>"pd1", "roles"=>["production-db"]}, {"name"=>"pd2", "roles"=>["production-db"]}, {"name"=>"pw1", "roles"=>["production-web"]}, {"name"=>"pw2", "roles"=>["production-web"]}, {"name"=>"sa1", "roles"=>["staging-app"]}, {"name"=>"sa2", "roles"=>["staging-app"]}, {"name"=>"sd1", "roles"=>["staging-db"]}, {"name"=>"sd2", "roles"=>["staging-db"]}, {"name"=>"sw1", "roles"=>["staging-web"]}, {"name"=>"sw2", "roles"=>["staging-web"]}]  
rake spec:pa1     # Run serverspec tests to pa1  
rake spec:pa2     # Run serverspec tests to pa2  
rake spec:pd1     # Run serverspec tests to pd1  
rake spec:pd2     # Run serverspec tests to pd2  
rake spec:pw1     # Run serverspec tests to pw1  
rake spec:pw2     # Run serverspec tests to pw2  
rake spec:sa1     # Run serverspec tests to sa1  
rake spec:sa2     # Run serverspec tests to sa2  
rake spec:sd1     # Run serverspec tests to sd1  
rake spec:sd2     # Run serverspec tests to sd2  
rake spec:sw1     # Run serverspec tests to sw1  
rake spec:sw2     # Run serverspec tests to sw2  
rake spec:zabbix  # Run serverspec tests to zabbix  

