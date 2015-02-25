class Asset
  attr_reader :id
  attr_reader :strategy, :uid, :acl
  attr_reader :status_id, :meta

  STATUSES = {
    pending: 1,
    completed: 2,
    cancelled: 3,
    deleted: 4,
  }
  ID_TO_STATUSES = STATUSES.invert

  def initialize(id: nil,
                 strategy:,
                 uid:,
                 acl:,
                 status_id: 1,
                 meta: {})
    @id = id
    @strategy = strategy
    @uid = uid
    @acl = acl
    @status_id = status_id
    @meta = meta
  end

  def status
    ID_TO_STATUSES[status_id]
  end

  def self.find(id)
    persistance.find(id)
  end

  def self.persistance
    @persistance ||= PersistedModel.new(
      model: self,
      dataset: DB[:assets]
    )
  end
end
