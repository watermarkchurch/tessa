ENV['RACK_ENV'] ||= "development"

require 'bundler/setup'
Bundler.require(:default)

Dotenv.load(".env.#{ENV['RACK_ENV']}", ".env")

DATABASE_URL ||= ENV['DATABASE_URL'] || fail("You must configure DATABASE_URL envvar")
DB = Sequel.connect(DATABASE_URL)
DB.extension :pg_json
Sequel.default_timezone = :utc

APP_ROOT = File.expand_path("../..", __FILE__)
PRELOAD_PATHS = %w[
  lib
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

Dir[File.join(APP_ROOT, "config", "initializers", "*.rb")].each do |init|
  require init
end

require "#{APP_ROOT}/config/application"

