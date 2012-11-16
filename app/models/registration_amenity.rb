class RegistrationAmenity < ActiveRecord::Base
  belongs_to :amenities_events
  belongs_to :event_registration
end
