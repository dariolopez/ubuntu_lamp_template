# The application role, which runs PHP 5.6 and the applications

# All attributes would be defined here

# An example of defining some sites:
node.default['apps'] = {
  'example.com' => { # This assumes a templates/default/apache2/sites-enabled/example.com.conf.erb
    git_repo: 'git@git...',
    target_branch: 'repo branch',
    deploy_key: 'ssh key...'
  }
}

# Run the default recipe
include_recipe "#{cookbook_name}::default"

# Apache2 - we will use the event MPM and connect to PHP-FPM by default
include_recipe "#{cookbook_name}::apache2"

# Memcached - If not used directly by the application, disable
# we will use the db_master's memcached for session handling
# this local memcached will be used as a fast local in-memory cache
# for applications like Drupal and Wordpress which can use it properly.
include_recipe "#{cookbook_name}::memcached"

# Varnish - Will be VERY safe/default to start with, simply caching
# static requests. TODO: Add prefabs for Wordpress, Drupal, etc.
include_recipe "#{cookbook_name}::varnish"

# Configure this server as a PHP web server
include_recipe "#{cookbook_name}::php56"
