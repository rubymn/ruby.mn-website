class EventController < ApplicationController
  before_filter :login_required

  def index
  end

  def create
    if request.get?
      render :action=>'event_form'
    elsif request.post? and params['event']['id'].nil? 
      evt = Event.new params["event"]
      evt.user=current_user
      evt.save
      redirect_to :action=>"index"
    elsif request.post? and !params['event']['id'].nil?
      evt = Event.find(params['event']['id'])
      evt.update_attributes params["event"]
      redirect_to :action=>'index'
    end
  end


  def admdestroy
    if current_user.admin?
      Event.destroy(params[:id])
      redirect_to :controller=>'admin', :action=>'index'
    else
      session[:uid]=nil
      redirect_to :controller=>'user', :action=>'login'
    end
  end
  def destroy
    u = current_user
    id=params[:id]
    evt = Event.find(id)
    if u.events.include? evt
      evt.destroy
      redirect_to :controller=>'welcome', :action=>'index'
    else
      session[:uid]=nil
      redirect_to :controller=>"welcome", :action=>'index'
    end

  end

  def approve
    if current_user.admin?
      e = Event.find(params[:id])
      e.approved= true
      e.save!
      flash[:info] = 'Event Approved'
      redirect_to :controller=>'admin', :action=>'index'
    else
      flash[:error] = 'Access Denied'
      redirect_to :controller=>'user', :action=>'login'
    end

  end

  def edit
    id = params[:id]
    if request.get? and @event=Event.find(id)
      @id=id
      if @event.user == current_user
        render :action=> 'event_form'
      else
        session[:uid]=nil
        redirect_to :controller=>'welcome'
      end
    end
  end
end
