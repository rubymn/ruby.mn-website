require 'test_helper'

class EventTest < ActiveSupport::TestCase
  should_validate_presence_of :headline, :scheduled_time, :body, :user_id


end
