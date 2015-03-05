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
    serialized.to_json
  end

  patch "/:id/cancelled" do
    set_asset_status(:cancelled)
    serialized.to_json
  end

  get "/:id" do
    serialized.to_json
  end

  delete "/:id" do
    set_asset_status(:deleted)
    serialized.merge(
      delete_url: asset.url.delete,
    ).to_json
  end

  def asset
    @asset ||= Asset.find(params['id'])
  end

  def set_asset_status(status)
    Asset.persistence
      .update(asset, status_id: Asset::STATUSES[status])
  end

  def serialized
    {
      id: asset.id,
      status: asset.status,
      strategy: asset.strategy_name,
      meta: asset.meta,
      public_url: asset.url.public,
      private_url: asset.url.get,
    }
  end
end
