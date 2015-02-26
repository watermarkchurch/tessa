class Persistence
  attr_reader :model, :dataset

  def initialize(model:, dataset:)
    @model = model
    @dataset = dataset
  end

  def find(id)
    model.new dataset.where(id: id).first!
  rescue Sequel::NoMatchingRow
    raise RecordNotFound
  end


  class RecordNotFound < StandardError; end
end
