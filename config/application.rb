TessaApp = Rack::URLMap.new(
  "/uploads" => UploadsController
)

DB = Sequel.connect(DATABASE_URL)
