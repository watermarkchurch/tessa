class Asset
  attr_reader :id
  attr_reader :strategy, :uid, :acl
  attr_reader :status_id, :meta

  STATUSES = {
    1 => :pending,
    2 => :completed,
    3 => :cancelled,
    4 => :deleted,
  }

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
    STATUSES[status_id]
  end

  def self.find(id)
    new DB[:assets].where(id: id).first!
  end
end
