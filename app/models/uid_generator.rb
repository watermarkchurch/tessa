require 'securerandom'

class UidGenerator
  attr_reader :strategy, :name

  DELIMITER = "/"
  DEFAULT_NAME = "file"
  MAX_NAME_LENGTH = 512

  def initialize(strategy:, name: nil)
    @strategy = strategy
    @name = sanitize_name(name)
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

  def sanitize_name(name)
    if name.nil? || name.empty?
      DEFAULT_NAME
    else
      truncate_name name
        .strip
        .gsub(/[^a-zA-Z0-9.]+/, '-')
        .gsub(/-{2,}/, '-')
    end
  end

  def truncate_name(name, max: MAX_NAME_LENGTH)
    if name.size > max
      name[name.size - max, max]
    else
      name
    end
  end
end
