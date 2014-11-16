# The MySQL master server recipe, which runs MariaDB 10.0

node.default['mysql'] = {
  server_id: 1
}

include_recipe "#{cookbook_name}::default"
include_recipe "#{cookbook_name}::mariadb"
