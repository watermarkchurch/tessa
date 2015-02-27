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
    if instance_valid?(instance)
      instance.id = dataset.insert(instance.attributes)
      instance
    else
      false
    end
  end

  def update(instance, attrs)
    instance.attributes = attrs
    if instance_valid?(instance)
      dataset.where(id: instance.id).update(instance.attributes)
    else
      0
    end
  end

  def delete(instance)
    dataset.where(id: instance.id).delete
  end

  class RecordNotFound < StandardError; end

  private

  def instance_valid?(instance)
    !instance.respond_to?(:valid?) || instance.valid?
  end
end
