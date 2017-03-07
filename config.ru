require File.expand_path("../config/environment", __FILE__)

use Rack::CommonLogger, logger

run ProtectedTessaApp

# Needed because of forking Puma webserver
DB.disconnect
