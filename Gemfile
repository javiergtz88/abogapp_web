source 'https://rubygems.org'
gem 'rails', '4.1.8'
gem 'sqlite3'
gem 'bootstrap-sass', '~> 3.3.1'
gem 'sprockets', '2.12.3'
gem 'bcrypt-ruby', '3.1.2'
gem 'sass-rails'
gem 'uglifier', '2.1.1'
gem 'coffee-rails', '4.0.1'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'
gem 'rb-readline' # gem for console
gem 'figaro' # for env vars
# gem "config" # for env vars
gem 'annotate' # schema in models

gem 'conekta' # new payments

group :development, :test do
  gem 'jdbc-mysql', platform: :jruby
  gem 'activerecord-jdbc-adapter', platform: :jruby

  gem 'rspec-rails', '3.1.0'
  gem 'guard-rspec', '4.5.0'
  gem 'spork-rails', '4.0.0'
  gem 'guard-spork', '2.1.0'
  gem 'spring'
  gem 'factory_girl_rails', '4.2.0'
  gem 'faker'

  # Dev Tools
  # gem 'bullet' # Find N + 1 queries
  gem 'rails_best_practices', require: false
  gem 'traceroute', require: false # Fund unused or unreachable routes
  # gem 'rack-mini-profiler', require: false
  # gem 'flamegraph' # graphs for rack-mini-profiler
  gem 'rubocop', require: false
  gem 'rubycritic', require: false
  gem 'brakeman', require: false
  gem 'annotate', require: false # schema in models
  gem 'railroady'
  gem 'flay', require: false
  gem 'flog', require: false
  gem 'heckle', require: false
  # Automated deployment stuff
  gem 'capistrano', '~> 3.4.0',         require: false
  gem 'capistrano-rvm',                 require: false
  gem 'capistrano-rails', '~> 1.1',     require: false
  gem 'capistrano-bundler', '~> 1.1.2', require: false
  gem 'capistrano3-puma',               require: false
  gem 'capistrano-passenger',           require: false
  gem 'capistrano-ext',                 require: false
  gem 'capistrano3-nginx', '~> 2.0',    require: false
end

group :test do
  #gem 'rb-inotify', '~> 0.9.7'
  gem 'capybara', '2.4.4'
  gem 'cucumber-rails', '1.3.0', require: false
  gem 'libnotify' if /linux/ =~ RUBY_PLATFORM
  gem 'growl' if /darwin/ =~ RUBY_PLATFORM
  gem 'database_cleaner'
  gem 'launchy'
  gem 'selenium-webdriver'
end

group :doc do
  gem 'sdoc', '~> 0.4.0', require: false
end

group :production do
  gem 'mysql2', '~> 0.3.18', platform: :ruby
  gem 'jdbc-mysql', platform: :jruby
  gem 'activerecord-jdbc-adapter', platform: :jruby
  #gem 'rails_12factor', '0.0.2'
end

# Custom
gem 'devise'
gem 'omniauth-facebook'
gem 'fb_graph2', '~> 0.7.4'
gem 'koala', '~> 2.2'
gem 'high_voltage', '~> 2.2.1'
gem 'paperclip', '~> 4.2' # paperclip
gem 'cancancan' # cancan
gem 'simple_token_authentication', '~> 1.0' # see semver.org, trabjar en esto despues
# gem 'paypal-sdk-rest' #https://github.com/paypal/PayPal-Ruby-SDK
gem 'httparty'

# required for JS runtime
gem 'therubyracer'
