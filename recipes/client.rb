#
# Cookbook Name:: chef-cfssl
# Recipe:: client
#
# Copyright (C) 2016 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

template '/etc/systemd/system/cfssl.service' do
  source 'cfssl.service.erb'
  owner 'root'
  group 'root'
  mode 00755
  notifies :run, "execute[cfssl daemon-reload]", :immediately
end

execute "cfssl daemon-reload" do
  command "systemctl daemon-reload"
  action :nothing
end

template "#{node['cfssl']['config_path']}/conf/cfssl.json" do
  source 'cfssl.json.erb'
  owner node['cfssl']['service']['user']
  group node['cfssl']['service']['group']
  mode 00755
  notifies :restart, "service[cfssl]", :immediately
end

service 'cfssl' do
  supports :start => true, :restart => true
  action [ :enable, :start ]
end
