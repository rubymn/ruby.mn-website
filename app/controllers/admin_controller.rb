class AdminController < ApplicationController
  before_filter :admin_required

  def index
    @events = Event.find(:all, :conditions=>"approved = 0")
  end
  def approve
    if current_user.admin?
      e = Event.find(params[:id])
      e.approved= true
      e.save!
      flash[:info] = 'Event Approved'
      redirect_to :controller=>'admin', :action=>'index'
    else
      bounce
    end

  end

  private
  def admin_required
    if session[:uid]
      if current_user.role.to_i == 2
        return true
      else
        flash[:error]= 'Access Denied (hoser).'
        redirect_to :controller=>'user', :action=>'login'
        session[:uid]=nil
      end
    end
  end
end
