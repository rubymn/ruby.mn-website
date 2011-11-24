class AdminController < ApplicationController
  before_filter :admin_required

  def index
    @events = Event.unapproved
  end

  def approve
    if current_user.admin?
      e = Event.find(params[:id])
      e.approved = true
      e.save!
      redirect_to admin_index_path, :notice => 'Event Approved'
    else
      bounce
    end
  end
end
