# Install and configure Apache2

package 'apache2'

user_ulimit 'www-data' do
  filehandle_limit 8192
  core_hard_limit 'unlimited'
end

service 'acache2' do
  service_name 'apache2'
  action [:enable, :start]
  supports restart: true, reload: true, status: true
end
