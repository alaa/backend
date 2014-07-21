default[:unicorn][:worker_timeout] = 30
default[:unicorn][:preload_app] = false
default[:unicorn][:working_directory] = '/usr/share/nginx/www/current'
default[:unicorn][:worker_processes] = [node[:cpu][:total].to_i * 2, 4].min
default[:unicorn][:preload_app] = false
default[:unicorn][:before_fork] = 'sleep 1'
default[:unicorn][:port] = '8080'
default[:unicorn][:stderr_path] = '/var/log/unicorn.log'
default[:unicorn][:stdout_path] = '/var/log/unicorn.log'
default[:unicorn][:env] = 'production'

default[:nginx][:default_site_enabled] = false
default[:nginx][:servername] = "_"
default[:nginx][:port] = 80
default[:nginx][:root] = "/usr/share/nginx/www"

default[:backend][:app] = 'rails-unicorn'
default[:backend][:deploy_to] = '/usr/share/nginx/www'
default[:backend][:repo] = 'https://github.com/alaa/rails4-unicorn.git'
default[:backend][:user] = 'deployer'
