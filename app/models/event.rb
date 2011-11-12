class Event < ActiveRecord::Base
  belongs_to :user

  validates :headline,       :presence => true
  validates :scheduled_time, :presence => true
  validates :body,           :presence => true
  validates :user_id,        :presence => true

  scope :approved, includes(:user).where(:approved => true).limit(5)
  scope :unapproved, where(:approved => false)
end
