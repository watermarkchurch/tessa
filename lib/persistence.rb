class Persistence
  attr_reader :model, :dataset

  FILTERED_ATTRIBUTES = %i[id]

  def initialize(model:, dataset:)
    @model = model
    @dataset = dataset
  end

  def query(args)
    dataset.where(args).map { |record| model.new record }
  end

  def find(id)
    model.new dataset.where(id: id).first!
  rescue Sequel::NoMatchingRow
    raise RecordNotFound
  end

  def create(attrs)
    instance = model.new attrs
    if instance_valid?(instance)
      instance.id = dataset.insert(instance_attributes(instance))
      instance
    else
      false
    end
  end

  def update(instance, attrs)
    instance.attributes = attrs
    if instance_valid?(instance)
      dataset
        .where(id: instance.id)
        .update(instance_attributes(instance, attrs.keys))
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

  def instance_attributes(instance, subset=instance.attributes.keys)
    instance.attributes.select { |key, _|
      !FILTERED_ATTRIBUTES.include?(key) &&
        subset.include?(key)
    }
  end
end
