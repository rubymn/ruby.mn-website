# == Schema Information
#
# Table name: for_hires
#
#  id      :integer          not null, primary key
#  blurb   :text             not null
#  email   :string(200)      default(""), not null
#  title   :string(200)      default(""), not null
#  user_id :integer
#

require 'test_helper'

class ForHireTest < ActiveSupport::TestCase
  should belong_to :user
  should validate_presence_of :user_id
  should validate_presence_of :title
  should validate_presence_of :email
  should validate_presence_of :blurb
end
