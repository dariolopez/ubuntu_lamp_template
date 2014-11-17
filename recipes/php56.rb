# Install and configure PHP5.6

# Add the 5.6 repo
apt_repository 'php5.6' do
  uri          'ppa:ondrej/php5-5.6'
  distribution node['lsb']['codename']
end

# Install php5.6
package 'python-software-properties'
package 'php5'
package 'php5-fpm'
# And the most commonly used plugins, although this should be audited (TODO)
package 'php5-mysql'
package 'php5-memcached'
# package 'php5-curl'
# package 'php5-mcrypt'
# package 'php5-gd'
# package 'php5-sqlite'

# Configure OP cache template
template '/etc/php5/mods-available/opcache.ini' do
  source 'php/05_opcache.ini.erb'
  owner 'root'
  group 'root'
  mode '0644'
  variables(
    nothing: 'here'
  )
  notifies :restart, 'service[php5-fpm]'
end

# PHP FPM pool
template '/etc/php5/fpm/pool.d/www.conf' do
  source 'php/pool.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  variables(
    nothing: 'here'
  )
  notifies :restart, 'service[php5-fpm]'
end

# PHP.ini
template '/etc/php5/fpm/php.ini' do
  source 'php/php.ini.erb'
  owner 'root'
  group 'root'
  mode '0644'
  variables(
    nothing: 'here'
  )
  notifies :restart, 'service[php5-fpm]'
end

# PHP-FPM configuration
template '/etc/php5/fpm/php-fpm.conf' do
  source 'php/php-fpm.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  variables(
    nothing: 'here'
  )
  notifies :restart, 'service[php5-fpm]'
end

# Ensure PHP-FPM is running
service 'php5-fpm' do
  service_name 'php5-fpm'
  provider Chef::Provider::Service::Upstart
  supports restart: true, status: true
  action [:enable, :start]
end

# TODO: Add a check to ensure 5.6 actually got installed, and we didn't mess up
# and install 5.5 by accident.

# TODO: Configure PHP to use Memcached for sessions
# TODO: Install NewRelic PHP if a newrelic key is defined
