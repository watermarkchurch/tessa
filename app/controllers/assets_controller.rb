class AssetsController < Sinatra::Base

  before do
    content_type "application/json"
  end

  error Persistence::RecordNotFound do
    status 404
    {}.to_json
  end

  patch "/:id/completed" do
    Asset.persistence.update(asset, status_id: Asset::STATUSES[:completed])
    asset_json
  end

  def asset
    @asset ||= Asset.find(params['id'])
  end

  def asset_json
    {
      id: asset.id,
      status: asset.status,
      acl: asset.acl,
      strategy: asset.strategy,
      meta: asset.meta,
    }.to_json
  end
end
