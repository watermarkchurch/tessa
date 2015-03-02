require 'yaml'

STRATEGIES = Class.new(Strategy)
DEFAULT_STRATEGY_OPTIONS = {
  region: ENV['AWS_REGION'],
  credentials: {
    access_key_id: ENV['AWS_ACCESS_KEY_ID'],
    secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
  }
}

YAML.load_file(File.join(APP_ROOT, 'config', 'strategies.yml')).each do |name, options|
  STRATEGIES.add(name, DEFAULT_STRATEGY_OPTIONS.merge(options))
end

