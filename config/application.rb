# frozen_string_literal: true

TessaApp = Rack::URLMap.new(
  '/' => RootController,
  '/assets' => AssetsController,
  '/uploads' => UploadsController,
  '/health-check' => HealthCheckController
)
