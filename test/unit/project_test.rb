require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  should_belong_to :user
  should_validate_presence_of :title, :description, :url, :user_id

end
