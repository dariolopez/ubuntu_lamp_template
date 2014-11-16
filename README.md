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


How to use this cookbook:
====================

1. Copy the cookbook into your desired cookbook directory, naming it as desired
2. Remove the CHANGELOG.md, README.md and Berksfile.lock files
3. Write a new README.md, start a new CHANGELOG.md, and "berks install"
4. Edit metadata.rb and replace the cookbook name and author
5. Edit .kitchen.yml and replace the cookbook name
6. Edit Vagrantfile and replace the cookbook name

Next, you can "berks upload" and create 3 roles:

1. "app", with a "run_list" of "recipe[COOKBOOKNAME::role_app]"
2. "db_master", with a "run_list" of "recipe[COOKBOOKNAME::role_db_master]"
3. "db_slave", with a "run_list" of "recipe[COOKBOOKNAME::role_db_slave]"

Afterwards, simply bootstrap the nodes! To build a single node test app, just:

run_list: "role[app]", "role[db_master]"

Recommended prod environment:
====================

I recommend at least 2gb of RAM for all testing purposes, as MariaDB10, Apache, PHP-FPM, Memcached, Varnish, and NewRelic will all be included. For best performance to price ratio, I recommend at least 3 4gb or 8gb "General" compute nodes from Rackspace.com for "app" servers. The "db_master" server should be a Rackspace.com OnMetal Compute instance with an attached SSD Volume (unless your MySQL size is very very small, and you can deal with a 30gb disk). If this is a very very IO intensive database, use the OnMetal IO server. The "db_slave" can be a 8gb "General" server. LAMP stacks depend massively on their master database for performance. Take great care tuning MySQL - this cookbook will self tune to some extent, but make sure you read the included guide carefully. The tuning guide is located at TUNING.md.

Rant:
====================

This cookbook is meant to illustrate a collection of best practices I have been designing for Chef. As such:

1. The will never be an attributes file, ever. Chef attributes are bad. Recipes instead.
2. Roles _are_ recipes, no exception. A "app" server only runs "role[app]", which in turn is _only_ "recipes/role_app.rb".
3. Never reference itself unless otherwise unavoidable - instead using #{cookbook_name}.
4. Prioritize real application testing and Time-To-Production over code testing and philosophy.
5. Strive to include as few foreign cookbooks as possible.
6. Converge speed is a top concern - all cruft left at the door.
7. Recipes function not only as a infrastructure-as-code, but also as code-as-support-guide. A Ops person reading a recipe ought to be able to understand how to support it, via comments and clear code.
8. Discourage the usage of mixed sources of truth - favoring clarity over philsophies.
