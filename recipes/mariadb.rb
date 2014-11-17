# Install and Configure MariaDB 10.0

# Add the MariaDB 10 repo
apt_repository 'mariadb' do
  uri 'http://ftp.osuosl.org/pub/mariadb/repo/10.0/ubuntu'
  distribution 'trusty'
  components ['main']
  keyserver 'hkp://keyserver.ubuntu.com:80'
  key '0xcbcb082a1bb943db'
  action :add
end

# Install mariadb server!
package 'mariadb-server' do
  action [:upgrade, :install]
end

open_files_limit = 8192

template '/etc/mysql/my.cnf' do
  source node['mysql']['template_name']
  owner 'root'
  group 'root'
  mode '0644'
  variables(
    listen: '0.0.0.0',
    server_id: node['mysql']['server_id'],
    open_files_limit: open_files_limit
  )
  notifies :restart, 'service[mysql]'
end

# MySQL ulimit setting
user_ulimit 'mysql' do
  filehandle_limit open_files_limit
  core_hard_limit 'unlimited'
end

# Ensure service is runing
service 'mysql' do
  service_name 'mysql'
  supports restart: true, status: true
  action [:enable, :start]
end

# Run grants
execute 'mysql_constants' do
  command 'mysql < /root/mysql_constants.sql'
  ignore_failure true
  action :nothing
end
template '/root/mysql_constants.sql' do
  source 'mysql/mysql_constants.sql.erb'
  notifies :run, resources(execute: 'mysql_constants'), :immediately
end

# TODO: OS Tuning
