#
# Cookbook Name:: chef-cfssl
# Recipe:: gen_ca
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

%w{ ca }.each do |dir|
  directory "#{node['cfssl']['config_path']}/#{dir}" do
    owner node['cfssl']['service']['user']
    group node['cfssl']['service']['group']
    mode 00700
    recursive true
    action :create
  end
end

node['cfssl']['ca'].each do |key, val|
  template "#{node['cfssl']['config_path']}/csr/#{key}.json" do
    source 'csr/ca.json.erb'
    owner node['cfssl']['service']['user']
    group node['cfssl']['service']['group']
    mode 00755
    variables :key => key, :val => val
    notifies :run, "execute[gen_ca #{key}]", :immediately
  end

  execute "gen_ca #{key}" do
    command "#{node['cfssl']['install_path']}/cfssl gencert -initca #{node['cfssl']['config_path']}/csr/#{key}.json | #{node['cfssl']['install_path']}/cfssljson -bare #{key}"
    user node['cfssl']['service']['user']
    group node['cfssl']['service']['group']
    cwd "#{node['cfssl']['config_path']}/ca"
    action :nothing
  end
end
