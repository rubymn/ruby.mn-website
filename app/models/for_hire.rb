class ForHire < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :user_id, :title, :email, :blurb
end
