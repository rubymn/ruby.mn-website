class EventController < ApplicationController
  before_filter :login_required

  def index
  end

  def create
    if request.get?
      render :action=>'event_form'
    elsif request.post? and params['event']['id'].nil? 
      evt = Event.new params["event"]
      evt.user=session[:user]
      evt.save
      redirect_to :action=>"index"
    elsif request.post? and !params['event']['id'].nil?
      evt = Event.find(params['event']['id'])
      evt.update_attributes params["event"]
      redirect_to :action=>'index'
    end
  end


  def destroy
    u = session[:user]
    id=params[:id]
    evt = Event.find(id)
    if u.events.include? evt
      evt.destroy
      redirect_to :controller=>'welcome', :action=>'index'
    else
      session[:user]=nil
      redirect_to :controller=>"welcome", :action=>'index'
    end

  end

  def edit
    id = params[:id]
    if request.get? and @event=Event.find(id)
      @id=id
      if @event.user == session[:user]
        render :action=> 'event_form'
      else
        session[:user] = nil
        redirect_to :controller=>'welcome'
      end
    end
  end
end
