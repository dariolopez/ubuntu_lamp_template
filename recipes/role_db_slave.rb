# The MySQL slave server recipe, which runs MariaDB 10.0

include_recipe "#{cookbook_name}::default"

include_recipe "#{cookbook_name}::mariadb"
