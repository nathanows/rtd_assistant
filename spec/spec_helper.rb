require 'simplecov'
SimpleCov.start do
  add_filter "/spec/"
end

require 'rails_helper'
require 'capybara/rspec'
require 'shoulda/matchers'
require 'geocoder'

Dir[Rails.root.join("spec/support/*.rb")].each { |f| require f  }

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.include OmniauthHelper

  config.include GeocoderHelper

  config.include FactoryGirl::Syntax::Methods

  config.before(:suite) do
    begin
      DatabaseCleaner.start
      FactoryGirl.lint
    ensure
      DatabaseCleaner.clean
    end
  end
end
