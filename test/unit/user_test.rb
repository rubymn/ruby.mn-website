require 'test_helper'

class UserTest < ActiveSupport::TestCase
  subject {Factory.create :user}
  should_have_one :for_hire
  should_have_many :events
  should_have_many :openings
  should_have_many :projects
  should_validate_presence_of  :login
  should_validate_uniqueness_of :login, :email
end
