ubuntu_lamp_template
====================

A template for a LAMP stack application on Ubuntu 14.04 featuring PHP5.6 and
MariaDB 10.0 - it is designed to be as fast as possible, require as few
cookbooks as possible, and make things as obvious as possible.

A stand-alone test node, which can deploy and test an entire app looks like so:

  run_list: {
    recipe[COOKBOOK::role_app],
    recipe[COOKBOOK::role_db_master]
  }

It's that easy! Make sure to modify the recipes/role_app.rb recipe so that you
actually deploy a site. It will deploy a little example by default.


Things to do after you copy and rename this cookbook:
====================

1. Remove the CHANGELOG.md, README.md and Berksfile.lock files
2. Write a new README.md, start a new CHANGELOG.md, and "berks install"
3. Edit metadata.rb and replace the cookbook name and author
4. Edit .kitchen.yml and replace the cookbook name
5. Edit Vagrantfile and replace the cookbook name

Next, you can "berks upload" to the customers environment, and create 3 roles:

1. "app", with a "run_list" of "recipe[COOKBOOKNAME::role_app]"
2. "db_master", with a "run_list" of "recipe[COOKBOOKNAME::role_db_master]"
3. "db_slave", with a "run_list" of "recipe[COOKBOOKNAME::role_db_slave]"

Afterwards, simply bootstrap the nodes! To build a single node test app, just:

run_list: "role[app]", "role[db_master]"
