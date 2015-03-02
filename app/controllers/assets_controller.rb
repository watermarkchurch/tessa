class AssetsController < Sinatra::Base

  before do
    content_type "application/json"
  end

  error Persistence::RecordNotFound do
    status 404
    {}.to_json
  end

  patch "/:id/completed" do
    set_asset_status(:completed)
    asset_json
  end

  patch "/:id/cancelled" do
    set_asset_status(:cancelled)
    asset_json
  end

  get "/:id" do
    asset_json
  end

  def asset
    @asset ||= Asset.find(params['id'])
  end

  def set_asset_status(status)
    Asset.persistence
      .update(asset, status_id: Asset::STATUSES[status])
  end

  def asset_json
    {
      id: asset.id,
      status: asset.status,
      strategy: asset.strategy,
      meta: asset.meta,
      public_url: "URL",
      private_url: "URL",
    }.to_json
  end
end
