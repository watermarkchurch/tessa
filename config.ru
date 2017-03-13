require File.expand_path("../config/environment", __FILE__)

use Rack::CommonLogger, logger
if FORCE_SSL
  use Rack::SSL
end

run ProtectedTessaApp

# Needed because of forking Puma webserver
DB.disconnect
