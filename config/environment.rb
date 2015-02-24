ENV['RACK_ENV'] ||= "development"

require 'bundler/setup'
Bundler.require(:default)

if ENV['RACK_ENV'] == "test"
  Dotenv.load(".env.test")
else
  Dotenv.load
end

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

DATABASE_URL ||= ENV['DATABASE_URL'] || fail("You must configure DATABASE_URL envvar")

require "#{APP_ROOT}/config/application"

