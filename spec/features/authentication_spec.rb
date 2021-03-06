require 'spec_helper'

RSpec.feature "Protection wrapped application" do

  def app
    ProtectedTessaApp
  end

  scenario "Without authentication it returns 401" do
    post "/uploads"
    expect(response.status).to eq(401)
  end

  scenario "With correct username and bad password returns 401" do
    basic_authorize 'test_user', 'test_password1'
    post "/uploads"
    expect(response.status).to eq(401)
  end

  scenario "With unknown username and blank password returns 401" do
    basic_authorize "unknown_user", nil
    post "/uploads"
    expect(response.status).to eq(401)
  end

  scenario "With auth credentials it returns 200" do
    basic_authorize 'test_user', 'test_password'
    post "/uploads"
    expect(response.status).to eq(200)
  end

end
