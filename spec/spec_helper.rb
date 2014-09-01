require "codeclimate-test-reporter"
CodeClimate::TestReporter.start
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
require 'capybara/rspec'
require 'capybara/poltergeist'
require 'spork'
require 'webmock/rspec'

Spork.prefork do
  Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

  Capybara.javascript_driver = :poltergeist
  Capybara.default_wait_time = 5

  RSpec.configure do |config|
    config.infer_spec_type_from_file_location!
    config.filter_run :focus
    config.run_all_when_everything_filtered = true

    if config.files_to_run.one?
      config.default_formatter = 'doc'
    end

    config.profile_examples = 5
    config.order = :random

    Kernel.srand config.seed
    WebMock.disable_net_connect!(allow: "codeclimate.com")
    
    config.expect_with :rspec do |expectations|
      expectations.syntax = :expect
    end

    config.mock_with :rspec do |mocks|
      mocks.syntax = :expect
      mocks.verify_partial_doubles = true
    end

    config.include Rails.application.routes.url_helpers
    config.include FactoryGirl::Syntax::Methods
    config.include Capybara::DSL
    config.include ResponseMacros
  end
end

Spork.each_run do
  FactoryGirl.reload
end
