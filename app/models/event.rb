class Event < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :headline, :scheduled_time, :body, :user_id

  named_scope :approved, :include => :user, :conditions => {:approved => true}, :limit => 5
end
