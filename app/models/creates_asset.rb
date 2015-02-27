class CreatesAsset
  include Virtus.model

  attribute :persistence, Object, default: -> (*_) { Asset.persistence }
  attribute :strategy, String, default: "default"
  attribute :acl, String, default: "private"
  attribute :meta, Hash, default: {}
  attribute :uid, String, default: :generate_uid

  def call
    return @asset if @asset
    create_args = asset_args
    create_args[:meta] = Sequel.pg_json(create_args[:meta])
    @asset = persistence.create(create_args)
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
