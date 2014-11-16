# The default recipe, included by all other recipes PRIOR to anything else

# Run and apt-get update
include_recipe 'apt'

package 'software-properties-common'
package 'vim'
package 'git'
