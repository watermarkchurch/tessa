Fabricator(:asset) do
  initialize_with { |f| p(f.to_hash); Asset.new(f.to_hash) }

  strategy "default"
  uid { |attrs| GeneratesUid.call(strategy: attrs[:strategy]) }
  status_id 1
end
