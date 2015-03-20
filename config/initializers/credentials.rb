require 'yaml'

CREDENTIALS ||=
  YAML.load_file(File.join(APP_ROOT, "config", "creds.yml"))
