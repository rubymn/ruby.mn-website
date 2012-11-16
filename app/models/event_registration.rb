class EventRegistration < ActiveRecord::Base
  belongs_to :event
  belongs_to :user

  has_many :registration_amenities
  has_many :amenities_events
end
