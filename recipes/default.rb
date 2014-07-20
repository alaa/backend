#
# Cookbook Name:: backend
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'base::default'
include_recipe 'nginx::repo'
include_recipe 'apt::default'
include_recipe 'nginx::default'



template '/usr/share/nginx/html/index.html' do
  source 'index.html.erb'
  group  'root'
  owner  'root'
  mode   0644
  variables({
    :title => "Hello from chef!",
    :platform => node['platform_family']
  })
end
