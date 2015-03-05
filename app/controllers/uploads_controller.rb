class UploadsController < Sinatra::Base
  before do
    content_type "application/json"
  end

  UPLOAD_PARAMS = %w[
    strategy
    name
    size
    mime_type
  ]

  post "/" do
    upload = Upload.new(upload_params)
    if upload.save
      upload.to_json
    else
      status 422
      {
        error: "Invalid options for new upload!",
      }.to_json
    end
  end

  def upload_params
    params.select { |k,v| UPLOAD_PARAMS.include?(k) }
  end
end
