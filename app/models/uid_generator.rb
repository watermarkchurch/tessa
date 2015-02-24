require 'securerandom'

class UidGenerator
  attr_reader :strategy, :name

  DELIMITER = "/"

  def initialize(strategy:, name: "file")
    @strategy = strategy
    @name = name
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

end
