require 'yaml'
require 'json'

credential_config_file = File.join(APP_ROOT, "config", "creds.yml")

if ENV['TESSA_CREDENTIALS']
  CREDENTIALS ||= JSON.parse(ENV['TESSA_CREDENTIALS'])
elsif File.exists?(credential_config_file)
  CREDENTIALS ||= YAML.load_file(credential_config_file)
else
  raise "Configuration error: TESSA_CREDENTIALS not set and no config/creds.yml file"
end
