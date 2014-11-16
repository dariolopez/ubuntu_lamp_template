# Install and configure Apache2

package 'apache2'

service 'acache2' do
  service_name 'apache2'
  action [:enable, :start]
  supports restart: true, reload: true, status: true
end
