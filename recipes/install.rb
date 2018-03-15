#
# Cookbook Name:: chef-cfssl
# Recipe:: install
#
# Copyright:: 2018,  Vegard Hansen
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

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
