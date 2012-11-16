class AmenitiesEvent < ActiveRecord::Base
  has_many :registration_amenities
  has_many :event_registrations
end
