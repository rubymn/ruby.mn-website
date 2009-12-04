class Event < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :headline, :scheduled_time, :body, :user_id
end
