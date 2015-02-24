require 'rspec/core/rake_task'

task :default => ['specs']
MIGRATIONS_PATH = File.expand_path("../db/migrate", __FILE__)

RSpec::Core::RakeTask.new :specs do |task|
  task.pattern = Dir['spec/**/*_spec.rb']
end

task :environment do
  require File.expand_path("../config/environment", __FILE__)
end

namespace :db do
  task :migrate => :environment do |t, args|
    Sequel.extension :migration
    Sequel::Migrator.run(DB, MIGRATIONS_PATH, use_transactions: true)
  end
end

