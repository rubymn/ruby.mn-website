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

class ForHire < ActiveRecord::Base
  belongs_to :user

  validates :user_id, :presence => true
  validates :title,   :presence => true
  validates :email,   :presence => true
  validates :blurb,   :presence => true
end
