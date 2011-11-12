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
      flash[:notice] = 'Event Approved'
      redirect_to admindex_path
    else
      bounce
    end
  end
end
