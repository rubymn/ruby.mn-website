require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  should belong_to :user
  should validate_presence_of :title
  should validate_presence_of :description
  should validate_presence_of :url
  should validate_presence_of :user_id
end
