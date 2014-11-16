# The default recipe, included by all other recipes PRIOR to anything else

# Run and apt-get update
include_recipe 'apt'

# Allow easy creation of users via the Chef User cookbook
include_recipe 'user'

package 'software-properties-common'
package 'vim'
package 'git'

# Include NewRelic
include_recipe "#{cookbook_name}::newrelic"

# FOR RACKSPACE CUSTOMERS:
node.default['rackspace'] = {
  cloud_credentials: {
    username: nil,
    api_key: nil
  }
}


# Include Rackspace Operations Rolebook - For Managed DevOps customer only
include_recipe "rackops_rolebook"
