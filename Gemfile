source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.0'

gem 'rails', '~> 7.0.4'
gem 'puma', '~> 5.0'

gem 'tzinfo-data', platforms: %i[ mingw mswin x64_mingw jruby ]
gem 'bootsnap', require: false
gem 'redis'
gem 'redis-namespace'
gem 'redis-rails'
gem 'dotenv-rails'

group :development, :test do
  gem 'sqlite3', '~> 1.4'
  gem 'debug', platforms: %i[ mri mingw x64_mingw ]
  gem 'rspec-rails'
end
