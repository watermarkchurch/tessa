class Asset
  include Virtus.model

  STATUSES = {
    pending: 1,
    completed: 2,
    cancelled: 3,
    deleted: 4,
  }
  ID_TO_STATUSES = STATUSES.invert

  attribute :id, Integer
  attribute :strategy, String
  attribute :uid, String
  attribute :acl, String
  attribute :status_id, Integer, default: STATUSES[:pending]
  attribute :meta, Object, default: {}

  def valid?
    strategy && uid && acl
  end

  def status
    ID_TO_STATUSES[status_id]
  end

  def self.find(id)
    persistence.find(id)
  end

  def self.persistence
    @persistence ||= Persistence.new(
      model: self,
      dataset: DB[:assets]
    )
  end
end
