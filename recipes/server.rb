#
# Cookbook Name:: chef-cfssl
# Recipe:: server
#
# Copyright (C) 2016 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

template '/etc/systemd/system/cfssl.service' do
  source 'cfssl.service.erb'
  owner 'root'
  group 'root'
  mode 00744
end

template "#{node['cfssl']['config_path']}/conf/authsign.json" do
  source 'authsign.json.erb'
  owner 'root'
  group 'root'
  mode 00744
  notifies :restart, "service[cfssl]", :immediately
end

service 'cfssl' do
  supports :start => true, :restart => true
  action [ :enable, :start ]
end
