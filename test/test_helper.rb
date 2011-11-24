ENV["RAILS_ENV"]     = "test"
TCRBB_LIST_ADDRESS   = 'test@example.com'
ADMIN_ADDRESS        = 'admin@example.com'
NOTIFICATION_ADDRESS = 'notifications@example.com'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'custom_helper'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
  include CustomHelper
end
