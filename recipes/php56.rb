# Install and configure PHP5.6

# We'll need to update after adding the PPA
execute 'apt-get-update' do
  command 'apt-get update'
  ignore_failure true
  action :nothing
end

# Add the 5.6 repo and force an apt-get update
apt_repository 'php5.6' do
  uri          'ppa:ondrej/php5-5.6'
  distribution node['lsb']['codename']
  # notifies :run, resources(execute: 'apt-get-update'), :immediately
end

# Install python-software-properties and force another update
package 'python-software-properties'
# package 'python-software-properties' do
# notifies :run, resources(execute: 'apt-get-update'), :immediately
# end

# Finally, install php5.6
package 'php5'
package 'php5-fpm'

# And the most commonly used plugins, although this should be audited (TODO)
package 'php5-curl'
package 'php5-mysql'
package 'php5-mcrypt'
# package 'php5-gd'
# package 'php5-sqlite'

# Ensure PHP-FPM is running
service 'php5-fpm' do
  service_name 'php5-fpm'
  provider Chef::Provider::Service::Upstart
  supports restart: true, reload: true, status: true
  action [:enable, :start]
end

# TODO: Add a check to ensure 5.6 actually got installed, and we didn't mess up
# and install 5.5 by accident.

# TODO: Configure PHP-FPM via template
# TODO: Configure PHP to use Memcached for sessions
# TODO: Install NewRelic PHP if a newrelic key is defined
