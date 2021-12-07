source 'https://rubygems.org'

ruby '3.0.3'

gem 'rails', '~> 6.1.0'

gem 'bootsnap', '>= 1.4.4', require: false
gem 'bounded_context'
gem 'dry-monads'
gem 'dry-struct'
gem 'dry-types'
gem 'faker'
gem 'pg', '~> 1.1.3'
gem 'puma', '~> 5.0'
gem 'rails_event_store', '~> 2.3.0'
gem 'redis'
gem 'ruby_event_store-sidekiq_scheduler'
gem 'sass-rails', '>= 6'
gem 'sidekiq'
gem 'tailwindcss-rails', '~> 0.4.3'
gem 'turbolinks', '~> 5'
gem 'tzinfo-data', platforms: %i(mingw mswin x64_mingw jruby)
gem 'webpacker', '~> 5.0'

group :development, :test do
  gem 'byebug', platforms: %i(mri mingw x64_mingw)
  gem 'pry-byebug'
  gem 'pry-doc'
  gem 'pry-rails'
end

group :development, :test do
  gem 'rubocop', require: false
  gem 'rubocop-performance', '~> 1.11'
  gem 'rubocop-rails', '~> 2.9', require: false
  gem 'rubocop-rspec', '~> 2.1', require: false
end

group :development do
  gem 'listen', '~> 3.3'
  gem 'rack-mini-profiler', '~> 2.0'
  gem 'spring'
  gem 'web-console', '>= 4.1.0'
end

group :test do
  gem 'rexml'
  gem 'rspec-rails'
  gem 'ruby_event_store-rspec'
end
