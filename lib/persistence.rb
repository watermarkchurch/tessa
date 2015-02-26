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

  def create(attrs)
    instance = model.new attrs
    if !instance.respond_to?(:valid?) || instance.valid?
      instance.id = dataset.insert(attrs)
      instance
    else
      false
    end
  end

  class RecordNotFound < StandardError; end
end
