class AssetsController < Sinatra::Base

  error Sequel::NoMatchingRow do
    content_type "application/json"
    status 404
    {}.to_json
  end

  patch "/:id/completed" do
    content_type "application/json"
    asset = Asset.find(params['id'])
    DB[:assets].where(id: asset.id).update(status_id: Asset::STATUSES[:completed])
    %{{
      "id": #{params['id']},
      "status": "completed"
    }}
  end

end