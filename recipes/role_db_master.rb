
include_recipe "#{cookbook_name}::default"

# The MySQL master server recipe, which runs MariaDB 10.0
node.default['mysql'] = {
  server_id: 1,
  template_name: 'mysql/my.cnf.erb'
}
include_recipe "#{cookbook_name}::mariadb"

# Include Memcached on the master server for PHP session handling
include_recipe "#{cookbook_name}::memcached"
