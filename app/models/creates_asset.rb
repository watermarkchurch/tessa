class CreatesAsset
  attr_reader :dataset
  attr_reader :strategy, :acl, :uid
  attr_reader :meta

  def initialize(args={})
    @dataset = args.fetch(:dataset) { DB[:assets] }
    @strategy = args.fetch(:strategy) { "default" }
    @uid = args.fetch(:uid) { UidGenerator.call(strategy) }
    @acl = args.fetch(:acl) { "private" }
    @meta = args.fetch(:meta) { {} }
  end

  def call
    dataset.insert(asset_args)
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
