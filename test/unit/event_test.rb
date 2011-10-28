require 'test_helper'

class EventTest < ActiveSupport::TestCase
  should validate_presence_of :headline
  should validate_presence_of :scheduled_time
  should validate_presence_of :body
  should validate_presence_of :user_id
end
