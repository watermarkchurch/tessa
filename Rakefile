# frozen_string_literal: true

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new :specs do |task|
    task.pattern = Dir['spec/**/*_spec.rb']
  end
rescue LoadError
end

task default: ['specs']
MIGRATIONS_PATH = File.expand_path('db/migrate', __dir__)

task :environment do
  require File.expand_path('config/environment', __dir__)
end

desc 'Launch pry with the environment loaded'
task pry: :environment do
  require 'pry'
  Pry.start
end

desc 'Copy the example files into place'
task :setup do
  require 'fileutils'
  root = File.expand_path(__dir__)
  {
    File.join(root, 'config', 'creds.yml.example') =>
      File.join(root, 'config', 'creds.yml'),
    File.join(root, 'config', 'strategies.yml.example') =>
      File.join(root, 'config', 'strategies.yml')
  }.each do |source, dest|
    FileUtils.cp(source, dest) unless File.exist?(dest)
  end
end

namespace :db do
  task :ensure_env do
    ENV['RACK_ENV'] ||= 'development'

    require 'dotenv/load'

    Dotenv.load(".env.#{ENV['RACK_ENV']}.local", ".env.#{ENV['RACK_ENV']}", '.env')
    ENV.inspect
  end

  desc 'create the database'
  task create: :ensure_env do |_t, _args|
    puts <<~PW
      Creating the DB - when prompted for the password, please use: #{db_password}
    PW
    system "createdb -h #{db_host} -U #{db_user} #{db_name}"
  end

  desc 'drop the database'
  task drop: :environment do |_t, _args|
    system "dropdb -h #{db_host} -U #{db_user} #{db_name}"
  end

  desc 'migrate the database'
  task :migrate, [:version] => :environment do |_t, args|
    Sequel.extension :migration
    options = {
      use_transactions: true
    }
    options[:target] = args[:version].to_i if args[:version]
    Sequel::Migrator.run(DB, MIGRATIONS_PATH, options)
  end

  def db_host
    db_uri.host
  end

  def db_user
    db_uri.user
  end

  def db_name
    db_uri.path[1..-1]
  end

  def db_password
    db_uri.password
  end

  def db_uri
    URI(ENV['DATABASE_URL'])
  end
end
