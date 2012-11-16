class EventRegistration < ActiveRecord::Base
  belongs_to :event
  belongs_to :user
  has_many :amenities_events, :through => :registration_amenities
  has_many :registration_amenities
  accepts_nested_attributes_for :amenities_events
  validates :email, :presence => true

  attr_accessor :amenities_events_ids

  def amenities_events_ids=(amenity_ids)
    amenity_ids.each do |amenity_id|
      a = AmenitiesEvent.where(:amenity_id => amenity_id, :event_id => event_id)
      self.amenities_events << a
    end
  end

end
