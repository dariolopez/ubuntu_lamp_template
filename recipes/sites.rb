# Configure the example site - Read this and understand it!

app1 = 'example.com'
# Create a deployment user for this app
user_account app1

# We'll have varnish clear the cache for our site when we make a new deployment
execute 'clear_varnish_on_deploy' do
  command "varnishadm 'ban req.http.host ~ #{app1}'"
  ignore_failure true
  action :nothing
end

# Deploy the application - see https://docs.getchef.com/resource_deploy.html
application app1 do
  path "/var/www/#{app1}"
  owner app1
  group 'www-data'
  repository 'http://github.com/erulabs/example_lampstack_app'
  revision 'master'
  notifies :run, 'execute[clear_varnish_on_deploy]', :delayed
end

# Configure Apache
template "/etc/apache2/sites-enabled/#{app1}.conf" do
  source "apache2/sites-enabled/#{app1}.conf.erb"
  owner 'root'
  group 'root'
  mode '0644'
  variables(
    appname: app1
  )
  notifies :reload, 'service[apache2]'
end
