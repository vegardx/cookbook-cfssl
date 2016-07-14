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

node['cfssl']['packages'].each do |pkg|

  remote_file "#{node['cfssl']['install_path']}/#{pkg}" do
    source "#{node['cfssl']['download_url']}/#{node['cfssl']['version']}/#{pkg}_#{node['os']}-#{node['cfssl']['arch']}"
    mode 00744
    owner 'root'
    group 'root'
    checksum node['cfssl']['checksums'][node['cfssl']['arch']][pkg]
    notifies :create, "link[/usr/local/bin/#{pkg}]", :delayed
  end

  link "/usr/local/bin/#{pkg}" do
    to "#{node['cfssl']['install_path']}/#{pkg}"
    action :nothing
  end

end
