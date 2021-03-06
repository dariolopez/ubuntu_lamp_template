name             'ubuntu_lamp_template'
maintainer       'Seandon Mooy'
maintainer_email 'seandon.mooy@gmail.com'
license          'All rights reserved'
description      'Installs/Configures a modern LAMP stack on Ubuntu 14.04'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

# 14.04 LTS is our only target for this cookbook
supports 'ubuntu', '= 14.04'

depends 'apt'
depends 'user'
depends 'cron'
depends 'newrelic'
depends 'ulimit'
depends 'application'

# For Rackspace Customers Only - make sure to remove from Berksfile as well
depends 'rackops_rolebook'
depends 'rackspace_iptables'
depends 'rackspace_cloudbackup'
depends 'rackspace_cloudmonitoring'
depends 'platformstack'
depends 'kibana'
depends 'elasticsearch'
depends 'logstash'
depends 'elkstack'
