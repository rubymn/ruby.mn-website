class EventRegistrationsController < ApplicationController
  def new
    @event_registration = EventRegistration.new
    @event              = Event.find(params[:event_id])
    @event_registration.user_id  = current_user.id if current_user.present?
    @event_registration.email    = current_user.email if current_user.present?
    @event_registration.event_id = @event.id
  end

  def create
    @event_registration = EventRegistration.new(params[:id])
    if @event_registration.save
        redirect_to event_registration_path(@event_registration), :notice => 'Thanks For Registering!'
     else
        redirect_to new_event_registration_path, :notice => 'That didnt work'
     end
  end

  def show
    @event_registration = EventRegistration.find(params[:id])
  end
end
