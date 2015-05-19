require File.expand_path("../config/environment", __FILE__)

if ENV['LOGENTRIES_TOKEN']
  Sinatra::TessaLogger.logger = Le.new(ENV['LOGENTRIES_TOKEN'], local: true)
end

use Rack::CommonLogger, logger

run ProtectedTessaApp
