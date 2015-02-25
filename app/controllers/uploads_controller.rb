class UploadsController < Sinatra::Base
  before do
    content_type "application/json"
  end

  UPLOAD_PARAMS = %w[
    strategy
    acl
    name
    size
    mime_type
  ]

  post "/" do
    upload = Upload.new(upload_params)
    upload.save
    upload.to_json
  end

  def upload_params
    params.select { |k,v| UPLOAD_PARAMS.include?(k) }
  end
end
