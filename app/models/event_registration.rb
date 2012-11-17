class EventRegistration < ActiveRecord::Base
  belongs_to :event
  belongs_to :user
  has_many :amenities_events, :through => :registration_amenities
  has_many :registration_amenities
  accepts_nested_attributes_for :amenities_events
  validates :email, :presence => true

end
