ruby '2.3.3'
source "https://rubygems.org"

gem 'aws-sdk', '~>2'
gem 'bugsnag'
gem 'dotenv', '~>2.2.0'
gem 'pg', '~>0.18.1'
gem 'pry', '~>0.10.1', require: false
gem 'puma'
gem 'rack-ssl', '1.4.1'
gem 'rake', '~>10.4.2'
gem 'sinatra', '~>1.4.5', github: "sinatra/sinatra"
gem 'sequel', '~>4.19.0'
gem 'sequel_pg', '~>1.6.11', require: 'sequel'
gem 'virtus', '~>1.0.4'

group :development do
  gem 'fabrication', '~>2.12.2'
  gem 'rspec', '~>3.2.0'
  gem 'rack-test', '~>0.6.3'
  gem 'timecop', '~>0.7.1'
end

group :production do
  gem 'newrelic_rpm'
end
