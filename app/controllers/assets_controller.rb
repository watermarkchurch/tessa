class AssetsController < Sinatra::Base

  error Persistence::RecordNotFound do
    content_type "application/json"
    status 404
    {}.to_json
  end

  patch "/:id/completed" do
    content_type "application/json"
    asset = Asset.find(params['id'])
    Asset.persistence.update(asset, status_id: Asset::STATUSES[:completed])
    {
      id: asset.id,
      status: asset.status,
      acl: asset.acl,
      strategy: asset.strategy,
      meta: asset.meta,
    }.to_json
  end

end
