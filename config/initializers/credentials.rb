require 'yaml'

DIGEST_CREDENTIALS ||=
  YAML.load_file(File.join(APP_ROOT, "config", "creds.yml"))
