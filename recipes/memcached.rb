# Install and configure Memcached

package 'memcached'

template '/etc/memcached.conf' do
  source 'memcached.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  variables(
    listen: '0.0.0.0',
    user: 'memcache',
    port: 11_211,
    udp_port: 11_211,
    maxconn: 1024,
    memory: 256,
    max_object_size: '1m'
  )
  notifies :restart, 'service[memcached]'
end

service 'memcached' do
  service_name 'memcached'
  action [:enable, :start]
  provider Chef::Provider::Service::Upstart
  supports restart: true, reload: true, status: true
end
