require 'test_helper'

class ForHireTest < ActiveSupport::TestCase
  should_belong_to :user
  should_validate_presence_of :user_id, :title, :email, :blurb
end
