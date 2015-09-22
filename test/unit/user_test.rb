# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  login           :string(80)       default(""), not null
#  salted_password :string(40)       default(""), not null
#  email           :string(60)       default(""), not null
#  firstname       :string(40)
#  lastname        :string(40)
#  salt            :string(40)       default(""), not null
#  verified        :integer          default(0)
#  security_token  :string(40)
#  token_expiry    :datetime
#  deleted         :integer          default(0)
#  logged_in_at    :datetime
#  delete_after    :date
#  role            :string(10)
#  gravatar_email  :string(255)
#

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
