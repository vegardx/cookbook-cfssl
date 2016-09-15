#
# Cookbook Name:: chef-cfssl
# Recipe:: install
#
# Copyright (C) 2016 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

directory node['cfssl']['install_path'] do
  owner 'root'
  group 'root'
  mode 00744
  recursive true
  action :create
end

directory node['cfssl']['config_path'] do
  owner 'root'
  group 'root'
  mode 00744
  recursive true
  action :create
end

arch = node['cfssl']['arch']

node['cfssl']['packages'][arch].each do |pkg, crc|
  remote_file "#{node['cfssl']['install_path']}/#{pkg}" do
    source "#{node['cfssl']['download_url']}/#{node['cfssl']['version']}/#{pkg}_#{node['os']}-#{node['cfssl']['arch']}"
    mode 00744
    owner 'root'
    group 'root'
    checksum crc
    notifies :create, "link[/usr/local/bin/#{pkg}]", :delayed
  end

  link "/usr/local/bin/#{pkg}" do
    to "#{node['cfssl']['install_path']}/#{pkg}"
    action :nothing
  end
end
