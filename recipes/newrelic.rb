# Install newrelic

node.default['newrelic'] = {
  # Set license key here to enable newrelic
  license: nil,
  application_monitoring: {
    app_name: cookbook_name
  }
}
unless node.default['newrelic']['license'].nil?
  include_recipe 'newrelic'
  include_recipe 'newrelic::php_agent'
end
