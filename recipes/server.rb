#
# Cookbook Name:: chef-cfssl
# Recipe:: server
#
# Copyright (C) 2016 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

template '/etc/systemd/system/multirootca.service' do
  source 'multirootca.service.erb'
  owner 'root'
  group 'root'
  mode 00755
  notifies :run, "execute[multirootca daemon-reload]", :immediately
end

execute "multirootca daemon-reload" do
  command "systemctl daemon-reload"
  action :nothing
  notifies :restart, "service[multirootca]", :immediately
end

template "#{node['cfssl']['config_path']}/conf/multirootca.json" do
  source 'multirootca.json.erb'
  owner node['cfssl']['service']['user']
  group node['cfssl']['service']['group']
  mode 00755
  notifies :restart, "service[multirootca]", :immediately
end

template "#{node['cfssl']['config_path']}/conf/roots.conf" do
  source 'roots.conf.erb'
  owner node['cfssl']['service']['user']
  group node['cfssl']['service']['group']
  mode 00755
  notifies :restart, "service[multirootca]", :immediately
end

service 'multirootca' do
  supports :start => true, :restart => true
  action [ :enable, :start ]
end
