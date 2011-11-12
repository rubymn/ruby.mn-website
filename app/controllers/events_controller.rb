class EventsController < ApplicationController
  before_filter :login_required
  before_filter :admin_required, :only => :show

  def index
    if current_user.admin?
      @events = Event.order('scheduled_time DESC')
    else
      @user   = current_user
      @events = @user.events
    end
  end

  def user_index
    if logged_in? 
      if current_user.admin? && params[:user_id]
        @events = User.find(params[:user_id]).events.order("scheduled_time desc")
      else
        @events = current_user.events.order("scheduled_time desc")
      end
      render :template => 'events/index'
    else
      bounce
    end
  end

  def approve
    if current_user and current_user.admin?
      Event.find(params[:id]).approved=true
    else
      current_user.events.find(params[:id]).approved=true
    end
  end

  def create
    @event = current_user.events.create(params[:event])
    if @event.save
      redirect_to user_index_events_path
      Notifier.notify_event(@event).deliver
    else
      render :action => :new
    end
  end

  def update
    @event = Event.find(params[:id])
    @event.update_attributes(params[:event])
    if @event.save
      if current_user && current_user.admin?
        redirect_to event_path(@event)
      else
        redirect_to :action => :user_index
      end
    else
      render :action => :edit
    end
  end

  def new
    @event = Event.new
  end

  def destroy
    if current_user && current_user.admin?
      Event.destroy(params[:id])
      flash[:notice] = 'Event Deleted'
      redirect_to admindex_path
    else
      current_user.events.find(params[:id]).destroy
      flash[:notice] = 'Event was deleted'
      redirect_to :action => :user_index
    end
    
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
