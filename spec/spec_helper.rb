require 'rubygems'
require 'spork'
# require 'capybara/rspec'

# uncomment the following line to use spork with the debugger
# require 'spork/ext/ruby-debug'

Spork.prefork do
  ENV['RAILS_ENV'] ||= 'test'
  require File.expand_path('../../config/environment', __FILE__)
  require 'rspec/rails'

  RSpec.configure do |config|
    config.mock_with :rspec
    config.fixture_path = "#{::Rails.root}/spec/fixtures"
    config.use_transactional_fixtures = true
    config.infer_base_class_for_anonymous_controllers = false

    # extra starts
    # config.expect_with :rspec do |expectations|
    #  expectations.include_chain_clauses_in_custom_matcher_descriptions = true
    # end

    # config.filter_run :focus
    # config.run_all_when_everything_filtered = true
    # config.disable_monkey_patching!

    config.default_formatter = 'doc' if config.files_to_run.one?
    # estra ends

    config.order = 'default'
    config.include Capybara::DSL

    config.expect_with :rspec do |c|
      c.syntax = :expect
    end

    config.include Rails.application.routes.url_helpers
    config.include Devise::TestHelpers, type: :controller
  end
end

Spork.each_run do
  # This code will be run each time you run your specs.
end
