# Install and configure Apache2

# Use Apache 2.4.9, which includes the UDS patch for Unix Socket Support
apt_repository 'apache2' do
  uri          'ppa:ondrej/apache2'
  distribution node['lsb']['codename']
end

# Apache modules - the only one actually required is proxy_fcgi - but most legacy
# apps required HEADERS and REWRITE. Disable if not required!
apache2_modules = ['proxy_fcgi', 'headers', 'rewrite', 'mpm_event']
# Disable mod_php and the prefork MPM since we'll be using EVENT
disabled_apache2_modules = ['mpm_prefork', 'php5']

package 'apache2' do
  action [:upgrade, :install]
end

# Configure sites
include_recipe "#{cookbook_name}::sites"

# Set the Apache user's ulimit -n (file open limit)
user_ulimit 'www-data' do
  filehandle_limit 8192
  core_hard_limit 'unlimited'
end

# Apache2.conf
template '/etc/apache2/apache2.conf' do
  source 'apache2/apache2.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  variables(
    nothing: 'here'
  )
  notifies :restart, 'service[apache2]'
end

# ports.conf
template '/etc/apache2/ports.conf' do
  source 'apache2/ports.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  variables(
    nothing: 'here'
  )
  notifies :restart, 'service[apache2]'
end

# Disable the default site
file '/etc/apache2/sites-enabled/000-default.conf' do
  action :delete
  notifies :restart, 'service[apache2]'
end

# Disabled Apache2 modules
disabled_apache2_modules.each do |mod|
  file "/etc/apache2/mods-enabled/#{mod}.load" do
    action :delete
    notifies :restart, 'service[apache2]'
  end
  file "/etc/apache2/mods-enabled/#{mod}.conf" do
    action :delete
    notifies :restart, 'service[apache2]'
  end
end
# Apache2 modules
apache2_modules.each do |mod|
  link "/etc/apache2/mods-enabled/#{mod}.load" do
    to "/etc/apache2/mods-available/#{mod}.load"
    not_if { !File.exist?("/etc/apache2/mods-available/#{mod}.load") }
    notifies :restart, 'service[apache2]'
  end
  link "/etc/apache2/mods-enabled/#{mod}.conf" do
    to "/etc/apache2/mods-available/#{mod}.conf"
    not_if { !File.exist?("/etc/apache2/mods-available/#{mod}.conf") }
    notifies :restart, 'service[apache2]'
  end
end

add_iptables_rule('INPUT', '-p tcp --dport 80 -j ACCEPT', 50, 'allow HTTP')

# Apache2 service
service 'apache2' do
  service_name 'apache2'
  action [:enable, :start]
  supports restart: true, reload: true, status: true
end
