# The MySQL slave server recipe, which runs MariaDB 10.0

# TODO: Example of setting ID's based on IP addresses or node name
node.default['mysql'] = {
  server_id: 2,
  template_name: 'mysql/my.cnf.erb'
}

include_recipe "#{cookbook_name}::default"
include_recipe "#{cookbook_name}::mariadb"
