require 'yaml'
require 'json'

STRATEGIES = Class.new(Strategy)
DEFAULT_STRATEGY_OPTIONS = {
  region: ENV['AWS_REGION'],
  credentials: {
    access_key_id: ENV['AWS_ACCESS_KEY_ID'],
    secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
  }
}
strategy_config_file = File.join(APP_ROOT, 'config', 'strategies.yml')

if ENV['TESSA_STRATEGIES']
  raw_strategies = JSON.parse(ENV['TESSA_STRATEGIES'])
elsif File.exists?(strategy_config_file)
  raw_strategies = YAML.load_file(strategy_config_file)
else
  raise "Configuration error: TESSA_STRATEGIES is not set and no config/strategies.yml file."
end

raw_strategies.each do |name, options|
  STRATEGIES.add(name, DEFAULT_STRATEGY_OPTIONS.merge(options))
end

