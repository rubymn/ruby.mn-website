class Amenity < ActiveRecord::Base
  has_many :amenities_events
  has_many :events, :through => :amenities_events
end
