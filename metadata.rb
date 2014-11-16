name             'ubuntu_lamp_template'
maintainer       'Seandon Mooy'
maintainer_email 'seandon.mooy@gmail.com'
license          'All rights reserved'
description      'Installs/Configures a modern LAMP stack on Ubuntu 14.04'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.0.4'

# 14.04 LTS is our only target for this cookbook
supports 'ubuntu', '= 14.04'

depends 'apt'
