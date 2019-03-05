# frozen_string_literal: true

class HealthCheckController < Sinatra::Base
  get '/' do
    [200, {}, ['']]
  end
end
