module FactoryHelpers
  FACTORY_TABLE_MAP = {
    asset: :assets
  }

  def create(name, *args, &block)
    attributes = attributes_for(name, *args, &block)
    id = dataset_for_name(name).insert(attributes)
    Fabrication.manager[name].klass.new(
      attributes.merge(id: id)
    )
  end

  def attributes_for(name, *args, &block)
    Fabricate.attributes_for(name, *args, &block)
  end

  private

  def dataset_for_name(name)
    DB[FACTORY_TABLE_MAP[name.to_sym]]
  end
end
