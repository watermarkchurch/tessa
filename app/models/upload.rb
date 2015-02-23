class Upload
  attr_reader :strategy, :acl
  attr_reader :name, :size, :mime_type

  def initialize(args={})
    @strategy = args.fetch('strategy') { "default" }
    @acl = args.fetch('acl') { "private" }
    @name = args['name']
    @size = args['size'].to_i
    @mime_type = args['mime_type']
  end

  def save
  end

end
