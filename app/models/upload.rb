class Upload
  include Virtus.model

  attribute :strategy, String, default: "default"
  attribute :name, String
  attribute :size, Integer, default: 0
  attribute :date, Date, default: -> (*) { Date.today }
  attribute :mime_type, String
  attribute :username, String

  def save(asset_factory: CreatesAsset)
    return @asset if @asset
    if new_asset = asset_factory.call(asset_attributes)
      @asset = new_asset
    end
  end

  def to_json
    raise "You must call #save before serializing Upload" unless @asset
    {
      upload_url: @asset.url.put,
      upload_method: "put",
      asset_id: @asset.id,
    }.to_json
  end

  private

  def asset_attributes
    {
      strategy_name: strategy,
      username: username,
      meta: {
        "name" => name,
        "size" => size,
        "date" => date,
        "mime_type" => mime_type,
      }
    }
  end

end
