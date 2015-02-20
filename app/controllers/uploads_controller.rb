class UploadsController < Sinatra::Base
  before do
    content_type "application/json"
  end

  post "/" do
    upload = Upload.new(params)
    upload.save
    "{}"
  end

end
