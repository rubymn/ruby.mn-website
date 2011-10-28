require 'test_helper'

class UserTest < ActiveSupport::TestCase
  subject { Factory.create :user }

  should have_one :for_hire
  should have_many :events
  should have_many :openings
  should have_many :projects
  should validate_presence_of :login
  should validate_uniqueness_of :login
  should validate_uniqueness_of :email
end
