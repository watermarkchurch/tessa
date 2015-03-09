class AssetsController < Sinatra::Base

  set(:multiple_ids) do |only_multiple|
    condition do
      if only_multiple
        params['id'].include?(",")
      else
        !params['id'].include?(",")
      end
    end
  end

  before do
    content_type "application/json"
  end

  error Persistence::RecordNotFound do
    status 404
    {}.to_json
  end

  patch "/:id/completed" do
    set_asset_status(:completed)
    serialized(asset).to_json
  end

  patch "/:id/cancelled" do
    set_asset_status(:cancelled)
    serialized(asset).to_json
  end

  get "/:id", multiple_ids: false do
    serialized(asset).to_json
  end

  get "/:id", multiple_ids: true do
    assets(params['id'].split(",")).map do |asset|
      serialized(asset)
    end.to_json
  end

  delete "/:id" do
    set_asset_status(:deleted)
    serialized(asset).merge(
      delete_url: asset.url.delete,
    ).to_json
  end

  def asset
    @asset ||= Asset.find(params['id'])
  end

  def assets(ids)
    Asset.persistence.query(id: ids.collect(&:to_i))
  end

  def set_asset_status(status)
    Asset.persistence
      .update(asset, status_id: Asset::STATUSES[status])
  end

  def serialized(asset)
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
