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
      @@logger ||= Logger.new("#{APP_ROOT}/log/#{ENV['RACK_ENV']}.log")
    end

    def self.logger=(logger)
      @@logger = logger
    end

    def self.registered(app)
      app.helpers TessaLogger::Helpers
    end

  end

  register TessaLogger
end

