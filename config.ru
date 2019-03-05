# frozen_string_literal: true

require File.expand_path('config/environment', __dir__)

use Rack::CommonLogger, logger
use Rack::SSL if FORCE_SSL

run ProtectedTessaApp
run HealthCheckApp

# Needed because of forking Puma webserver
DB.disconnect
