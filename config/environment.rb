require 'bundler/setup'
Bundler.require(:default)

APP_ROOT = File.expand_path("../..", __FILE__)
PATH_ADDITIONS = %w[app]

PATH_ADDITIONS.each do |path|
  $LOAD_PATH.unshift(File.join(APP_ROOT, path))
end

require "#{APP_ROOT}/config/application"

