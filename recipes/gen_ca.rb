#
# Cookbook Name:: chef-cfssl
# Recipe:: gen_ca
#
# Copyright (C) 2016 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

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
