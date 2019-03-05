# frozen_string_literal: true

TessaApp = Rack::URLMap.new(
  '/uploads' => UploadsController,
  '/assets' => AssetsController,
  '/' => RootController
)

ProtectedTessaApp = Rack::Auth::Basic.new(TessaApp) do |username, password|
  CREDENTIALS[username] == password
end
ProtectedTessaApp.realm = 'Tessa Asset Manager'
