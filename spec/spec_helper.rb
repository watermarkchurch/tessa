require File.expand_path("../../config/environment", __FILE__)

require 'rack/test'
require 'json'

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
  config.warnings = true
  config.order = :random
  Kernel.srand config.seed

  if config.files_to_run.one?
    config.default_formatter = 'doc'
  end

  config.include ControllerSpecHelpers, type: :controller
  config.include RequestSpecHelpers, type: :request
end
