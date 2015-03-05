TessaApp = Rack::URLMap.new(
  "/uploads" => UploadsController,
  "/assets" => AssetsController,
)

DIGEST_CREDENTIALS ||= YAML.load_file(File.join(APP_ROOT, "config", "creds.yml"))
ProtectedTessaApp = Rack::Auth::Digest::MD5.new(TessaApp) do |username|
  DIGEST_CREDENTIALS[username]
end
ProtectedTessaApp.realm = 'Tessa Asset Manager'
ProtectedTessaApp.opaque = ENV['DIGEST_AUTH_OPAQUE']

Dir[File.join(APP_ROOT, "config", "initializers", "*.rb")].each do |init|
  require init
end
