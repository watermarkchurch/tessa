require File.expand_path("../config/environment", __FILE__)

file = File.new("#{APP_ROOT}/log/#{settings.environment}.log", 'a+')
file.sync = true
use Rack::CommonLogger, file

run ProtectedTessaApp
