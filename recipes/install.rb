#
# Cookbook Name:: chef-cfssl
# Recipe:: install
#
# Copyright (C) 2016 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

user node['cfssl']['service']['user'] do
  system true
  shell '/bin/false'
end

group node['cfssl']['service']['group']

directory node['cfssl']['install_path'] do
  owner 'root'
  group 'root'
  mode 00755
  recursive true
  action :create
end

directory node['cfssl']['config_path'] do
  owner node['cfssl']['service']['user']
  group node['cfssl']['service']['group']
  mode 00755
  recursive true
  action :create
end

%w{ conf cert csr }.each do |dir|
  directory "#{node['cfssl']['config_path']}/#{dir}" do
    owner node['cfssl']['service']['user']
    group node['cfssl']['service']['group']
    mode 00755
    recursive true
    action :create
  end
end

node['cfssl']['packages'][node['cfssl']['arch']].each do |pkg, crc|
  remote_file "#{node['cfssl']['install_path']}/#{pkg}" do
    source "#{node['cfssl']['download_url']}/#{node['cfssl']['version']}/#{pkg}_#{node['os']}-#{node['cfssl']['arch']}"
    mode 00755
    owner 'root'
    group 'root'
    checksum crc
    notifies :create, "link[/usr/local/bin/#{pkg}]", :immediately
  end

  link "/usr/local/bin/#{pkg}" do
    to "#{node['cfssl']['install_path']}/#{pkg}"
    action :nothing
  end
end
