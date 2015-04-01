require 'securerandom'

class GeneratesUid
  attr_reader :strategy_name, :name

  DELIMITER = "/"
  DEFAULT_NAME = "file"
  MAX_NAME_LENGTH = 512
  DEFAULT_PATH = ":year/:month/:day/:uuid/:name"

  def initialize(strategy_name:, name: nil)
    @strategy_name = strategy_name
    @name = handle_name(name)
  end

  def call(date: Date.today)
    path.dup.tap do |path|
      path_options(date: date).each do |name, value|
        path.gsub!(":#{name}", value)
      end
    end
  end

  def self.call(*args)
    new(*args).call
  end

  private

  def path
    DEFAULT_PATH
  end

  def path_options(date:)
    {
      year: date.year.to_s,
      month: date.strftime("%m"),
      day: date.strftime('%d'),
      uuid: SecureRandom.uuid,
      name: @name,
    }
  end

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
