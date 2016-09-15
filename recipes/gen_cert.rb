#
# Cookbook Name:: chef-cfssl
# Recipe:: gen_cert
#
# Copyright (C) 2016 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

%w{ conf cert }.each do |dir|
  directory "#{node['cfssl']['config_path']}/#{dir}" do
    owner 'root'
    group 'root'
    mode 00644
    recursive true
    action :create
  end
end

node['cfssl']['cert'].each do |key, val|
  template "#{node['cfssl']['config_path']}/conf/#{key}-csr.json" do
    source 'csr.json.erb'
    owner 'root'
    group 'root'
    mode 00644
    variables :key => key, :val => val
    notifies :run, "execute[gen_cert #{key}]", :immediately
  end

  execute "gen_cert #{key}" do
    command "#{node['cfssl']['install_path']}/cfssl gencert -remote #{node['cfssl']['remote']['address']}:#{node['cfssl']['remote']['port']} -config #{node['cfssl']['config_path']}/conf/cfssl.json -label #{val['label']} -profile #{val['profile']} -hostname #{node['hostname']} #{node['cfssl']['config_path']}/conf/#{key}-csr.json | #{node['cfssl']['install_path']}/cfssljson -bare #{key}"
    cwd "#{node['cfssl']['config_path']}/cert"
    action :nothing
  end
end
