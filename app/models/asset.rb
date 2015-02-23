class Asset
  attr_reader :strategy, :uid, :acl
  attr_reader :status_id, :meta

  def initialize(args={})
    @strategy = args.fetch('strategy') { 'default' }
    @uid = args['uid']
    @acl = args.fetch('acl') { 'private' }
    @status_id = args.fetch('status_id') { 1 }
    @meta = args.fetch('meta') { {} }
  end

end
