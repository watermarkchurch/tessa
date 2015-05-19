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
    presigned_url(:get, args)
  end

  def put(args={})
    presigned_url(:put, args)
  end

  def head(args={})
    presigned_url(:head, args)
  end

  def delete(args={})
    presigned_url(:delete, args)
  end

  def public
    object.public_url
  end

  private

  def presigned_url(method, args)
    object.presigned_url(method, default_args(method).merge(args))
  end

  def default_args(method)
    case method
    when :put
      { acl: strategy.acl, expires_in: strategy.ttl }
    else
      { expires_in: strategy.ttl }
    end
  end

end
