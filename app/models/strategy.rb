class Strategy
  include Virtus.model

  DEFAULT_REGION = "us-east-1"
  DEFAULT_TTL = 15*60

  attribute :name, Symbol
  attribute :bucket, String
  attribute :prefix, String, default: ""
  attribute :acl, Symbol, default: :private
  attribute :region, String, default: DEFAULT_REGION
  attribute :credentials, Hash[Symbol => String], default: {}
  attribute :ttl, Integer, default: DEFAULT_TTL

  def self.strategies
    @strategies ||= {}
  end

  def self.add(name, options)
    strategy = new(options.merge(name: name))
    strategies[strategy.name] = strategy
  end
end
