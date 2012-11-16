class EventRegistrationsController < ApplicationController
  def new
    @event_registration = EventRegistration.new
    @event              = Event.find(params[:event_id])
    @event_registration.user_id  = current_user.id if current_user.present?
    @event_registration.email    = current_user.email if current_user.present?
    @event_registration.event_id = @event.id
    @event.amenities.each do |a|
      @event_registration.amenities_events.build(:amenity_id => a.id, :event_id => @event.id)
    end
  end

  def create
    @event_registration = EventRegistration.new(params[:event_registration])

    if @event_registration.save
        redirect_to root_path, :notice => 'Thanks For Registering!'
     else
        redirect_to new_event_event_registration_path, :alert => 'Please provide an email address or sign in!'
     end
  end

  def show
    @event_registration = EventRegistration.find(params[:id])
  end
end
