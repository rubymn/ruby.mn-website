class AdminController < ApplicationController
  before_filter :admin_required

  def index
    @events = Event.unapproved
  end

  def approve
    event = Event.find(params[:id])
    event.approved = true
    event.save
    redirect_to admin_index_path, :notice => 'Event Approved'
  end
end
