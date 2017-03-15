require 'logger'

def logger
  Sinatra::TessaLogger.logger
end

module Sinatra
  module TessaLogger

    @@logger = nil

    module Helpers
      def logger
        Sinatra::TessaLogger.logger
      end
    end

    def self.logger
      @@logger ||= initialize_logger
    end

    def self.logger=(logger)
      @@logger = logger
    end

    def self.registered(app)
      app.helpers TessaLogger::Helpers
    end

    def self.initialize_logger(stdout=ENV['STDOUT_LOGGING'] == '1')
      if stdout
        Logger.new(STDOUT)
      else
        Logger.new("#{APP_ROOT}/log/#{ENV['RACK_ENV']}.log")
      end
    end

  end

  register TessaLogger
end

