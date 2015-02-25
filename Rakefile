require 'rspec/core/rake_task'

task :default => ['specs']
MIGRATIONS_PATH = File.expand_path("../db/migrate", __FILE__)

RSpec::Core::RakeTask.new :specs do |task|
  task.pattern = Dir['spec/**/*_spec.rb']
end

task :environment do
  require File.expand_path("../config/environment", __FILE__)
end

task :pry => :environment do
  require 'pry'
  Pry.start
end

namespace :db do

  task :create => :environment do |t, args|
    exec "createdb #{db_name}"
  end

  task :drop => :environment do |t, args|
    exec "dropdb #{db_name}"
  end

  desc "migrate the database"
  task :migrate, [:version] => :environment do |t, args|
    Sequel.extension :migration
    options = {
      use_transactions: true,
    }
    if args[:version]
      options[:target] = args[:version].to_i
    end
    Sequel::Migrator.run(DB, MIGRATIONS_PATH, options)
  end

  def db_name
    URI(ENV['DATABASE_URL']).path[1..-1]
  end
end

