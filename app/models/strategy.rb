class Strategy
  include Virtus.model

  DEFAULT_REGION = "us-east-1"
  DEFAULT_TTL = 15*60

  attribute :name, Symbol
  attribute :bucket, String
  attribute :prefix, String, default: ""
  attribute :acl, Symbol, default: :private
  attribute :region, String, default: DEFAULT_REGION
  attribute :credentials, Aws::Credentials
  attribute :ttl, Integer, default: DEFAULT_TTL

  def client
    @client ||= Aws::S3::Client.new(
      region: region,
      credentials: credentials
    )
  end

  def resource
    @resource ||= Aws::S3::Resource.new(
      client: client
    )
  end

  def object(uid)
    resource
      .bucket(bucket)
      .object(prefix + uid)
  end

  def credentials=(creds)
    @credentials = initialize_credentials(creds)
  end

  def self.strategies
    @strategies ||= {}
  end

  def self.add(name, options)
    strategy = new(options.merge(name: name))
    strategies[strategy.name] = strategy
  end

  private

  def initialize_credentials(creds)
    case creds
    when Aws::Credentials
      creds
    when Hash
      Aws::Credentials.new(creds[:access_key_id], creds[:secret_access_key])
    end
  end
end
