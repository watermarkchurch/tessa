TessaApp = Rack::URLMap.new(
  "/uploads" => UploadsController,
  "/assets" => AssetsController,
)

