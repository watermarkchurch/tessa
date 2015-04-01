Fabricator(:asset) do
  initialize_with { |f| p(f.to_hash); Asset.new(f.to_hash) }

  strategy_name "default"
  uid { |attrs| GeneratesUid.call }
  status_id Asset::STATUSES[:pending]
end
