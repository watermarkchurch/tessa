class StrategyURL
  attr_reader :strategy, :uid

  def initialize(strategy:, uid:)
    @strategy = strategy
    @uid = uid
  end

  def object
    @object ||= strategy.object(uid)
  end

end
