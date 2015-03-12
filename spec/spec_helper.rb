ENV['RACK_ENV'] = "test"
DIGEST_CREDENTIALS = { "test_user" => "test_password" }
require File.expand_path("../../config/environment", __FILE__)

require 'rack/test'
require 'json'
require 'timecop'
require 'fabrication'

Dir[File.join(File.expand_path("../support", __FILE__), "*.rb")].each do |file|
  require file
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.filter_run :focus
  config.run_all_when_everything_filtered = true
  config.disable_monkey_patching!
  config.warnings = false
  config.order = :random
  Kernel.srand config.seed

  if config.files_to_run.one?
    config.default_formatter = 'doc'
  end

  config.before(:suite) do
    DB[:assets].delete
  end

  config.around(:each) do |example|
    DB.transaction(rollback: :always, auto_savepoint: true) { example.run }
  end

  config.include FactoryHelpers
  config.include ControllerSpecHelpers, type: :controller

  config.include FeatureSpecHelpers, type: :feature
  config.alias_example_group_to :feature, type: :feature
  config.alias_example_to :scenario
end

begin
  DB.get(1)
rescue Sequel::DatabaseConnectionError
  puts "Test database connection failure. Attempting to build it."
  `RACK_ENV=test rake db:create && RACK_ENV=test rake db:migrate`
end
