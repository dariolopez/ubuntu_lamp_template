LAMP Tuning guide
===========================
By Seandon Mooy

This guide will help you optimize your environment for speed. The author enjoys cranking out every last ounce of performance from his services. This guide will help you do just that.

It is broken down into 5 sections: MariaDB, Varnish, Memcache, Apache and PHP

While this guide will target _this cookbook_, it will also contain general information regarding my experience with optimizing a modern LAMP stack on Ubuntu 14.04. The good news? There really isn't much to do.

MariaDB 10.0 tuning guide
============================
1. MySQL secure installation and auditing
  Make sure to log on and run mysql_secure_installation. After designing your cookbook, make sure you audit both the firewall on both MySQL servers and the MySQL users table. Chef will not get everything perfect, and there is no substitute for a proper audit before going to production.
2. Pool of threads
  We will have MariaDB use its "pool of threads" functionality to improve MySQL's performance in large concurrent read situations - as is very common in PHP applications. This setting can be disabled safely, and should probably be disabled if on a shared machine (such as a cloud server or vm without dedicated CPUs). Since this guide suggests using Rackspace OnMetal Compute servers, which feature dedicated CPUs, this setting is turned on by default.
3. INNODB buffer pool size
  The buffer pool size is critically important for performance and should be set to roughly 60% of the systems total memory. It ideally should be large enough to contain the entire data set, PLUS indexes. Use mysqltuner.pl to calculate this number. If performance is at all desired, the buffer pool should be larger than the sum total innodb data size by at least 25%.
4. Save and reload buffer pool cache on MySQL restart
  These two settings are enabled by default in this cookbook, but not in MariaDB 10. This has MySQL flush the INNODB buffer pool to disk before restarting, and loading it back during startup. In practice, it means a slightly longer MySQL restart time (for the OPs user, actual MySQL downtime is unchanged), and a warm buffer pool when making MYSQL tweaks.
5. Log file size tuning
  The goal with the INNODB log file size is to have INNODB keep about an hour of activity in its logs. You can compute the correct numbers, but only by gathering data during a busy usage period. By default, the settings in this cookbook will do nicely.
6. The query cache
  The query cache is an interesting beast. Leave the default settings defined in the example for at least 24 hours and then study the cache hit rate. One can do this manually, but the mysqltuner.pl script also does the calculation for you. If the Query Cache hit rate is lower than 25%, you should disable the query cache entirely. If the number of prunes is very high, MySQL is constantly contending to keep queries in the cache - and you should consider increasing the query_cache_size. If you raise the size to 512MB and you still see a huge number of prunes after about 24 hours, you should stop growing the query_cache_size and look at lowering the query_cache_limit. Watch the NewRelic graphs, make small changes once per 24 hours.  
7. Monitoring disk usage
  This is very important for new builds - often times the binary logging will exhaust a lot more disk space than one might imagine. Make sure you monitor the disk usage closely for at least 48 hours - making sure the binary log expire time is low enough as to keep a fair amount of disk space free. The default for this guide will keep 3 days of INNODB activity, which is more than enough for most applications.s

Varnish tuning guide
============================
1. File open limit
  Ensure the systems file open limit is high enough for Varnish to cope with incoming connections - this cookbook will set the limit to 4096, but make sure to monitor the logs for file open limit errors after about 24 hours of production traffic.
2. Varnish cache size
  Varnish's cache size should ideally be as small as possible, but should be large enough to contain the entirety of the applications static resources. If the application is 500MB, a Varnish cache size of 1GB should be enough to contain not only all static assets, but a good number of the dynamic pages as well. The smaller the Varnish cache size, the lower the Time To First Byte - since Varnish will need to scan less memory to determin if a file is in cache or not. Ensure Varnish isn't quickly reaching its cache and fighting for memory - if that is the case, increase the cache and look into the Purge functionality.
3. VCL Purge functionality
  To keep the varnish cache small and efficient, ensure your application purges assets from Varnish when they expire. Wordpress and Drupal both have plugins to this effect. The idea is that when a file or page is no longer needed, the application can notify Varnish, thus freeing up memory intelligently, rather than flushing some older (but still useful) document from cache.
4. Caching static files
  The default Varnish configuration this recipe provides will help cache static files - but consider ALSO using a service like CloudFlare.com or a Static Content Cache on a Rackspace Cloud Load Balancer
5. Grace time
  The default Varnish configuration will include a "grace" time, which allows Varnish to serve old content if the backend is replying slowly. This setting causes a very quick user experience, but can mask downtime in a fairly strange way. Make sure you understand what is happening!

Memcached tuning guide
============================
1. Using Memcached for sessions, or more?
  Assuming the application is a custom PHP application which makes no use of Memcached, keep memcached's memory limit small - as it will be used only for PHP sessions. Otherwise, make sure you monitor it and ensure it's not quickly reaching its cap. 256MB is plenty for most people - but a very heavily trafficed and complex Drupal site with Memcached configured in the application can use up to 1GB.

Apache 2.4 tuning guide
============================
1. MPM Event
2. Disabling modules, PHP, SSL
3. Working to disable mod_rewrite
4. .htaccess files

PHP 5.6 tuning guide
============================
1. PHP-FPM via Unix Socket
2. Tuning PHP-FPM's pool
3. Understanding threads


Application/Misc tuning guide
============================
1. Using Varnish PURGE
2. Using Memcached
3. Reading from the Slave DB
4. Using Load Balancer caching
5. Logging and fixing bad queries
6. NewRelic for the Application Developer
7. Fixing bad queries - the easy way(s) or the hard way(s)
8. Asset minification and bundling
9. Using a CDN
