require 'spec_helper'
require 'json'

RSpec.describe "uploads endpoints", type: :request do
  describe "POST to /uploads" do
    let(:data) { {} }

    before do
      post '/uploads', data
    end
  end
end
