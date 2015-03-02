class Upload
  include Virtus.model

  attribute :strategy, String, default: "default"
  attribute :name, String
  attribute :size, Integer, default: 0
  attribute :mime_type, String

  def save(asset_factory: CreatesAsset)
    @asset ||= asset_factory.call(asset_attributes)
    if @asset.id
      true
    else
      false
    end
  end

  def to_json
    raise "You must call #save before serializing Upload" unless @asset
    {
      upload_url: "url",
      upload_method: "method",
      success_url: "/assets/#{@asset.id}/completed",
      cancel_url: "/assets/#{@asset.id}/cancelled",
    }.to_json
  end

  private

  def asset_attributes
    {
      strategy: strategy,
      meta: {
        name: name,
        size: size,
        mime_type: mime_type,
      }
    }
  end

end
