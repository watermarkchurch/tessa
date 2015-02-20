require 'spec_helper'
require 'json'

RSpec.describe "uploads endpoints", type: :request do
  describe "POST to /uploads" do
    let(:data) { {} }

    before do
      post '/uploads', data
    end

    it "returns a 200" do
      expect(response.status).to eq(200)
    end

    it "contains valid json" do
      expect { json }.to_not raise_error
    end

    it "sets content_type to application/json" do
      expect(response.headers["Content-Type"]).to match(%r'application/json')
    end

    it "returns an upload_url"
    it "returns an upload_method"
    it "returns a success_url"
    it "returns a cancel_url"
  end
end
