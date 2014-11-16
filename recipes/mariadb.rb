# Install and Configure MariaDB 10.0

# We'll need to update after adding the PPA
execute 'apt-get-update' do
  command 'apt-get update'
  ignore_failure true
  action :nothing
end

# Add the MariaDB 10 repo
apt_repository 'mariadb' do
  uri 'http://ftp.osuosl.org/pub/mariadb/repo/10.0/ubuntu'
  distribution 'trusty'
  components ['main']
  keyserver 'hkp://keyserver.ubuntu.com:80'
  key '0xcbcb082a1bb943db'
  action :add
  # notifies :run, resources(execute: 'apt-get-update'), :immediately
end

# Install mariadb server!
package 'mariadb-server'

template '/etc/mysql/my.cnf' do
  source 'my.cnf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  variables(
    listen: '0.0.0.0',
    server_id: node['mysql']['server_id']
  )
  notifies :restart, 'service[mysql]'
end

# Ensure service is runing
service 'mysql' do
  service_name 'mysql'
  supports restart: true, status: true
  action [:enable, :start]
end

# TODO: Manage MariaDB config
# TODO: OS Tuning
