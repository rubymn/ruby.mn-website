class ForHire < ActiveRecord::Base
  belongs_to :user

  validates :user_id, :presence => true
  validates :title,   :presence => true
  validates :email,   :presence => true
  validates :blurb,   :presence => true
end
