class Upload
  attr_reader :strategy, :acl
  attr_reader :name, :size, :mime_type

  def initialize(args={})
    @strategy = args.fetch('strategy') { "default" }
    @acl = args.fetch('acl') { "private" }
    @name = args['name']
    @size = args['size'].to_i
    @mime_type = args['mime_type']
  end

  def save(asset_factory: CreatesAsset)
    @asset ||= asset_factory.call(asset_attributes)
    if @asset.id
      true
    else
      false
    end
  end

  private

  def asset_attributes
    {
      strategy: strategy,
      acl: acl,
      meta: {
        name: name,
        size: size,
        mime_type: mime_type,
      }
    }
  end

end
