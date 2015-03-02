class StrategyURL
  attr_reader :strategy, :uid

  def initialize(strategy:, uid:)
    @strategy = strategy
    @uid = uid
  end

  def object
    @object ||= strategy.object(uid)
  end

  def get(args={})
    object.presigned_url(:get, args)
  end

  def put(args={})
    object.presigned_url(:put, args)
  end

  def head(args={})
    object.presigned_url(:head, args)
  end

  def delete(args={})
    object.presigned_url(:delete, args)
  end

  def public
    object.public_url
  end

end
