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

# Ensure service is runing
service 'mysql' do
  service_name 'mysql'
  supports restart: true, reload: true, status: true
  provider Chef::Provider::Service::Upstart
  action [:enable, :start]
end

# TODO: Manage MariaDB config
# TODO: OS Tuning
