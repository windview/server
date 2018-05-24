require 'simplecov'
SimpleCov.start 'rails' do
  # any custom configs like groups and filters can be here at a central place

  # ignore rails stuff were not currently using
  add_filter "app/channels"
  add_filter "app/jobs"
  add_filter "app/mailers"
end
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/mock'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end
