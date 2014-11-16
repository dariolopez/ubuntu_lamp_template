ubuntu_lamp_template
====================

A template for a LAMP stack application on Ubuntu 14.04 featuring PHP5.6 and MariaDB 10.0

A stand-alone test node, which can deploy and test an entire app would look like this:

  run_list: {
    recipe[cookbook::role_app],
    recipe[cookbook::role_db-master]
  }

It's that easy!
