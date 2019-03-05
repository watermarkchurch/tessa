class RootController < Sinatra::Base
  get "/" do
    asset_status_counts = Asset::STATUSES.collect do |status, status_id|
      count = DB[:assets].where(status_id: status_id).count
      "<div><strong>#{status}:</strong> #{count}</div>"
    end
    %{
      <h1>It works!</h1>
      <h2>Strategies:</h2>
      <pre>#{STRATEGIES.strategies.keys.to_json}</pre>
      <h2>Assets:</h2>
    #{asset_status_counts.join}
      <div><strong>Total:</strong> #{DB[:assets].count}</div>
    }
  end
end
