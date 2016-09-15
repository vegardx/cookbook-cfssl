#
# Cookbook Name:: chef-cfssl
# Recipe:: gen_ca
#
# Copyright (C) 2016 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

%w{ conf ca }.each do |dir|
  directory "#{node['cfssl']['config_path']}/#{dir}" do
    owner 'root'
    group 'root'
    mode 00644
    recursive true
    action :create
  end
end

node['cfssl']['ca'].each do |key, val|
  template "#{node['cfssl']['config_path']}/conf/#{key}-csr.json" do
    source 'csr.json.erb'
    owner 'root'
    group 'root'
    mode 00644
    variables :key => key, :val => val
    notifies :run, "execute[gen_ca #{key}]", :immediately
  end

  execute "gen_ca #{key}" do
    command "#{node['cfssl']['install_path']}/cfssl gencert -initca #{node['cfssl']['config_path']}/conf/#{key}-csr.json | #{node['cfssl']['install_path']}/cfssljson -bare #{key}"
    cwd "#{node['cfssl']['config_path']}/ca"
    action :nothing
  end

end
