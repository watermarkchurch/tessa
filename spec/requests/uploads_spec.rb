require 'spec_helper'

RSpec.describe "uploads endpoints" do
  include Rack::Test::Methods
  alias :response :last_response

  def app
    TessaApp
  end

  describe "POST to /uploads" do
    let(:data) { {} }

    before do
      post '/uploads', data
    end

    it "returns a 200" do
      expect(response.status).to eq(200)
    end
    it "returns an upload_method"
    it "returns an upload_url"
    it "returns a success_url"
    it "returns a cancel_url"
  end
end
