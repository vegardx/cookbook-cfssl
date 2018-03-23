#
# Cookbook Name:: chef-cfssl
# Recipe:: server
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

template '/etc/systemd/system/multirootca.service' do
  source 'multirootca.service.erb'
  owner 'root'
  group 'root'
  mode 00755
  notifies :run, "execute[multirootca daemon-reload]", :immediately
  notifies :restart, "service[multirootca]", :immediately
end

execute "multirootca daemon-reload" do
  command "systemctl daemon-reload"
  action :nothing
  notifies :restart, "service[multirootca]", :immediately
end

node['cfssl']['server']['profiles'].each do |key, val|
  file "#{node['cfssl']['config_path']}/conf/server/#{key}.json" do
    content val.to_json
    owner node['cfssl']['service']['user']
    group node['cfssl']['service']['group']
    mode 00755
    action :create
    notifies :restart, "service[multirootca]", :immediately
  end
end

template "#{node['cfssl']['config_path']}/conf/server/roots.conf" do
  source 'roots.conf.erb'
  owner node['cfssl']['service']['user']
  group node['cfssl']['service']['group']
  mode 00755
  notifies :restart, "service[multirootca]", :immediately
end

service 'multirootca' do
  supports :start => true
  action [ :enable, :start ]
end
