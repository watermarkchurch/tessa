TessaApp = Rack::URLMap.new(
  "/uploads" => UploadsController,
  "/assets" => AssetsController,
)

Dir[File.join(APP_ROOT, "config", "initializers", "*.rb")].each do |init|
  require init
end
