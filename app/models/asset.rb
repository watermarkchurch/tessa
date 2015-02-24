class Asset
  attr_reader :strategy, :uid, :acl
  attr_reader :status_id, :meta

  def initialize(strategy:,
                 uid:,
                 acl:,
                 status_id: 1,
                 meta: {})
    @strategy = strategy
    @uid = uid
    @acl = acl
    @status_id = status_id
    @meta = meta
  end

end
