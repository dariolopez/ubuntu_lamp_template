# Install and configure Varnish

package 'varnish'

service 'varnish' do
  service_name 'varnish'
  action [:enable, :start]
  provider Chef::Provider::Service::Upstart
  supports restart: true, reload: true, status: true
end

# TODO Configure varnish
# TODO Setup prefabs for drupal, wordpress
