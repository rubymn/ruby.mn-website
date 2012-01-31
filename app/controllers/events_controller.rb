class EventsController < ApplicationController
  before_filter :login_required
  before_filter :admin_required, :only => :show

  def index
    if current_user.admin?
      @events = Event.includes(:user).order_scheduled_time_desc
    else
      @user   = current_user
      @events = @user.events
    end
  end

  def user_index
    if logged_in? 
      if current_user.admin? && params[:user_id]
        @user = User.find(params[:user_id])
      else
        @user = current_user
      end

      @events = @user.events.order_scheduled_time_desc
      render :template => 'events/index'
    else
      bounce
    end
  end

  def create
    @event = current_user.events.build(params[:event])

    if @event.save
      redirect_to user_index_events_path
      Notifier.notify_event(@event).deliver
    else
      render :action => :new
    end
  end

  def update
    @event = Event.find(params[:id])
    if @event.update_attributes(params[:event])
      redirect_to user_index_events_path, :notice => 'Event Updated'
    else
      render :action => :edit
    end
  end

  def new
    @event = Event.new :formatted_scheduled_time => Time.now
  end

  def destroy
    if current_user && current_user.admin?
      @event = Event.find(params[:id])
      redirect_path = admin_index_path
    else
      @event = current_user.events.find(params[:id])
      redirect_path = user_index_events_path
    end

    @event.destroy
    redirect_to redirect_path, :notice => 'Event Deleted'
  end
  

  def edit
    if current_user && current_user.admin?
      @event = Event.find(params[:id])
    else
      @event = current_user.events.find(params[:id])
    end
  end

  def show
    @event = Event.find(params[:id])
  end
end
