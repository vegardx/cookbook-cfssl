#
# Cookbook Name:: chef-cfssl
# Recipe:: gen_cert
#
# Copyright (C) 2016 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

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
