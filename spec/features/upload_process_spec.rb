require 'spec_helper'

RSpec.feature "Upload process" do

  scenario "Client initiates and successfully completes an upload" do
    upload = post_new_upload
    expect(upload['upload_url']).to_not be_nil

    expect(upload['success_url']).to_not be_nil
    patch upload['success_url']
    expect(response.status).to eq(200)
    asset = JSON.parse(response.body)
    expect(asset['id']).to_not be_nil
    expect(asset['status']).to eq("completed")
  end

  scenario "Client initiates an upload but then cancels it" do
    upload = post_new_upload

    expect(upload['cancel_url']).to_not be_nil
    patch upload['cancel_url']
    expect(response.status).to eq(200)
    asset = JSON.parse(response.body)
    expect(asset['status']).to eq("cancelled")
  end

  def post_new_upload(params=nil)
    params ||= {
      name: "myfile.txt",
      mime_type: "text/plain",
      size: 4,
    }
    post "/uploads", params
    expect(response.status).to eq(200)
    JSON.parse(response.body)
  end

end
