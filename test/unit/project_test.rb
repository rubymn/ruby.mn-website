# == Schema Information
#
# Table name: projects
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  title       :string(255)
#  url         :string(255)
#  source_url  :string(255)
#  description :text
#  created_at  :datetime
#  updated_at  :datetime
#

require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  should belong_to :user
  should validate_presence_of :title
  should validate_presence_of :description
  should validate_presence_of :url
  should validate_presence_of :user_id
end
