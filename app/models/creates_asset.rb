class CreatesAsset
  attr_reader :dataset
  attr_reader :strategy, :acl, :uid
  attr_reader :meta

  def initialize(args={})
    @dataset = args.fetch(:dataset) { DB[:assets] }
    @strategy = args.fetch(:strategy) { "default" }
    @acl = args.fetch(:acl) { "private" }
    @meta = args.fetch(:meta) { {} }

    @uid = args.fetch(:uid) {
      GeneratesUid.call(name: meta["name"], strategy: strategy)
    }
  end

  def call
    return @asset if @asset
    asset_id = dataset.insert(asset_args)
    @asset = Asset.new(asset_args.merge(id: asset_id))
  end

  def asset_args
    {
      strategy: strategy,
      acl: acl,
      uid: uid,
      meta: meta,
    }
  end

  def self.call(args={})
    new(args).call
  end

end
