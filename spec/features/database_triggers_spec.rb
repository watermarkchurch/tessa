require 'spec_helper'

RSpec.feature "Database triggers" do

  scenario "on assets create it sets created_at and updated_at" do
    asset_hash = DB[:assets].where(id: create(:asset).id).first!
    expect(asset_hash[:created_at]).to be_within(1).of(Time.now)
    expect(asset_hash[:updated_at]).to be_within(1).of(Time.now)
  end

  scenario "on assets update it touches the updated_at field" do
    asset = create(:asset, updated_at: Time.now - 5)
    query = DB[:assets].where(id: asset.id)
    query.update(uid: "new value")
    asset_hash = query.first!

    expect(asset_hash[:updated_at]).to be_within(1).of(Time.now)
  end

end
