require 'rspec/core/rake_task'

task :default => ['specs']

RSpec::Core::RakeTask.new :specs do |task|
  task.pattern = Dir['spec/**/*_spec.rb']
end
