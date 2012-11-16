class RegistrationAmenity < ActiveRecord::Base
  belongs_to :amenities_event
  belongs_to :event_registration
end
