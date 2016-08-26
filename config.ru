# This file is used by Rack-based servers to start the application.
app_env = 'production'
ENV['RAILS_ENV'] = app_env
ENV['RACK_ENV'] = app_env

require ::File.expand_path('../config/environment', __FILE__)
run Rails.application
