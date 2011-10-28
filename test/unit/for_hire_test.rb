require 'test_helper'

class ForHireTest < ActiveSupport::TestCase
  should belong_to :user
  should validate_presence_of :user_id
  should validate_presence_of :title
  should validate_presence_of :email
  should validate_presence_of :blurb
end
