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
include_recipe 'unicorn::default'
include_recipe 'nginx::default'

unicorn_config "/etc/unicorn/#{node[:backend][:app]}.rb" do
  listen({ node[:unicorn][:port] => node[:unicorn][:options] })
  working_directory ::File.join(node[:backend][:deploy_to], 'current')
  worker_timeout node[:unicorn][:worker_timeout]
  preload_app node[:unicorn][:preload_app]
  worker_processes node[:unicorn][:worker_processes]
  before_fork node[:unicorn][:before_fork]
end

template "/etc/nginx/sites-available/#{node[:backend][:app]}" do
  source "#{node[:backend][:app]}.erb"
  variables({
    :servername => node[:nginx][:servername],
    :port       => node[:nginx][:port],
    :root       => node[:nginx][:root]
  })
  notifies :run, "execute[nxensite]", :immediately
  notifies :run, "execute[unicorn]", :immediately
end

directory "/usr/share/nginx/www/shared/config/" do
  action :create
  recursive true
end

directory "/usr/share/nginx/www/shared/log/" do
  action :create
  recursive true
end

template "/usr/share/nginx/www/shared/config/database.yml" do
  source 'database.yml.erb'
end

execute "nxensite" do
  path ['/usr/sbin']
  cwd '/etc/nginx/sites-available/'
  command "nxensite #{node[:backend][:app]}"
end

execute "unicorn" do
  path ['/usr/sbin']
  cwd '/usr/share/nginx/www/current/'
  command "export rvmsudo_secure_path=1 && /bin/bash --login rvmsudo bundle exec unicorn -D -E #{node[:unicorn][:env]} -c /etc/unicorn/#{node[:backend][:app]}.rb"
end

user node[:backend][:user] do
  supports :manage_home => true
  comment "Application deployer user"
  home "/home/#{node[:backend][:user]}"
  shell "/bin/bash"
end

directory node[:backend][:deploy_to] do
  action :create
  recursive true
end

deploy_revision node[:backend][:deploy_to] do
  repo node[:backend][:repo]
  user node[:backend][:user]

  before_symlink do
    execute 'install dependencies' do
      command "/bin/bash --login rvmsudo bundle install"
      cwd release_path
      not_if "cd #{release_path} && /bin/bash --login rvmsudo bundle check"
    end
  end
  notifies :restart, "service[nginx]"
end
