require 'bundler/setup'
Bundler.require(:default)

APP_ROOT = File.expand_path("../..", __FILE__)
PRELOAD_PATHS = %w[
  app/controllers
  app/models
]

PRELOAD_PATHS.each do |path|
  $LOAD_PATH.unshift(File.join(APP_ROOT, path))
end

PRELOAD_PATHS.each do |path|
  Dir[File.join(APP_ROOT, path, "*.rb")].each do |file|
    require File.basename(file)
  end
end

require "#{APP_ROOT}/config/application"

