require 'strategy_accessor'

class Asset
  include Virtus.model
  include StrategyAccessor

  STATUSES = {
    pending: 1,
    completed: 2,
    cancelled: 3,
    deleted: 4,
  }
  ID_TO_STATUSES = STATUSES.invert

  attribute :id, Integer
  attribute :strategy_name, String, default: ""
  attribute :uid, String
  attribute :status_id, Integer, default: STATUSES[:pending]
  attribute :meta, Object, default: {}
  attribute :username, String
  attribute :created_at, Time
  attribute :updated_at, Time

  def valid?
    strategy && uid
  end

  def status
    ID_TO_STATUSES[status_id]
  end

  def url(strategy: self.strategy)
    @url ||= StrategyURL.new(strategy: strategy, uid: uid)
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
