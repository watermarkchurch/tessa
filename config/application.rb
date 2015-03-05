TessaApp = Rack::URLMap.new(
  "/uploads" => UploadsController,
  "/assets" => AssetsController,
  "/" => RootController,
)

ProtectedTessaApp = Rack::Auth::Digest::MD5.new(TessaApp) do |username|
  DIGEST_CREDENTIALS[username]
end
ProtectedTessaApp.realm = 'Tessa Asset Manager'
ProtectedTessaApp.opaque = ENV['DIGEST_AUTH_OPAQUE']

