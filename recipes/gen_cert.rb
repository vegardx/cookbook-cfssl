#
# Cookbook Name:: chef-cfssl
# Recipe:: gen_cert
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

node['cfssl']['cert'].each do |key, val|
  template "#{node['cfssl']['config_path']}/csr/#{key}.json" do
    source 'csr/cert.json.erb'
    owner node['cfssl']['service']['user']
    group node['cfssl']['service']['group']
    mode 00755
    variables :key => key, :val => val
    notifies :run, "execute[gen_cert #{key}]", :immediately
  end

  execute "gen_cert #{key}" do
    command "#{node['cfssl']['install_path']}/cfssl gencert -remote #{node['cfssl']['remote']['address']}:#{node['cfssl']['remote']['port']} -config #{node['cfssl']['config_path']}/conf/cfssl.json -label #{val['label']} -profile #{val['profile']} #{node['cfssl']['config_path']}/csr/#{key}.json | #{node['cfssl']['install_path']}/cfssljson -bare #{key}"
    cwd "#{node['cfssl']['config_path']}/cert"
    action :nothing
  end
end
