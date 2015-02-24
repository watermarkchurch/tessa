require 'securerandom'

class GeneratesUid
  attr_reader :strategy, :name

  DELIMITER = "/"
  DEFAULT_NAME = "file"
  MAX_NAME_LENGTH = 512

  def initialize(strategy:, name: nil)
    @strategy = strategy
    @name = handle_name(name)
  end

  def call(date: Date.today)
    [
      date.strftime("%Y#{DELIMITER}%m#{DELIMITER}%d"),
      SecureRandom.uuid,
      @name
    ].join(DELIMITER)
  end

  def self.call(*args)
    new(*args).call
  end

  private

  def handle_name(name)
    name = sanitize_name(name || "")
    name = truncate_name(name)
    if name.empty? || name == "-"
      DEFAULT_NAME
    else
      name
    end
  end

  def sanitize_name(name)
    truncate_name name
      .strip
      .gsub(/[^a-zA-Z0-9.]+/, '-')
      .gsub(/-{2,}/, '-')
  end

  def truncate_name(name, max: MAX_NAME_LENGTH)
    if name.size > max
      name[name.size - max, max]
    else
      name
    end
  end
end
