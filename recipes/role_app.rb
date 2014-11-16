# The application role, which runs PHP 5.6 and the applications

# All attributes would be defined here

# An example of defining some sites:
node.default['apps'] = {
  'example.com' => { # This assumes a files/default/example.com.conf
    git_repo: 'git@git...',
    target_branch: 'repo branch',
    deploy_key: 'ssh key...'
  }
}

# Run the default recipe
include_recipe "#{cookbook_name}::default"

# Configure this server as a PHP web server
include_recipe "#{cookbook_name}::php56"
