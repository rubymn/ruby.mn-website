class AmenitiesEvent < ActiveRecord::Base
  belongs_to :event
  belongs_to :amenity
  has_many :registration_amenities
  has_many :event_registrations, :through => :registration_amenities

end
