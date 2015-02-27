class CreatesAsset
  include Virtus.model

  attribute :dataset, Object, default: -> (*_) { DB[:assets] }
  attribute :strategy, String, default: "default"
  attribute :acl, String, default: "private"
  attribute :meta, Hash, default: {}
  attribute :uid, String, default: :generate_uid

  def call
    return @asset if @asset
    insert_args = asset_args
    insert_args[:meta] = Sequel.pg_json(insert_args[:meta])
    asset_id = dataset.insert(insert_args)
    @asset = Asset.new(asset_args.merge(id: asset_id))
  end

  def asset_args
    {
      strategy: strategy,
      acl: acl,
      uid: uid,
      meta: meta,
      status_id: 1,
    }
  end

  def self.call(args={})
    new(args).call
  end

  private

  def generate_uid
    GeneratesUid.call(name: meta["name"], strategy: strategy)
  end

end
