class AdminController < ApplicationController
  before_filter :admin_required

  def index
    @events = Event.find(:all, :conditions=>"approved = false")
  end
  def approve
    if current_user.admin?
      e = Event.find(params[:id])
      e.approved= true
      e.save!
      flash[:info] = 'Event Approved'
      redirect_to admindex_path
    else
      bounce
    end

  end

  private
  def admin_required
    if session[:uid]
      if current_user.role==  'admin'
        return true
      else
        flash[:error]= 'Access Denied (hoser).'
        redirect_to new_session_path
        session[:uid]=nil
      end
    end
  end
end
