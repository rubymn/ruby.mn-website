class EventsController < ApplicationController
  before_filter :login_required
  before_filter :admin_required, :only=>:show
  before_filter :find_user
  before_filter :find_res, :res_matches_user, :except=>[:index, :create, :new]

  def index
    if @user.admin?
      @events = Event.find(:all, :order=>'scheduled_time DESC')
    else
      @events = @user.events
    end
  end

  def create
    @event = @user.events.create(params[:event])
    if @event.save
      redirect_to events_path(@user)
      Notifier.deliver_notify_event(@event)
    else
      render :template=>'events/new'
    end
  end

  def update
    @event = @res
    @event.update_attributes(params[:event])
    if @event.save
      redirect_to event_path(@user, @event)
    else
      render :template=>'events/edit'
    end
  end

  def new
    @event = Event.new
  end


  def admdestroy
    if current_user.admin?
      Event.destroy(params[:id])
      redirect_to :controller=>'admin', :action=>'index'
    else
      bounce
    end
  end
  def destroy
    @res.destroy
    flash[:info]='Record Deleted'
    redirect_to events_path(current_user)
  end


  def edit
    @event=@res
  end

  def show
    @event = @res
  end

  private
  def find_res
    @res = @user.events.find(params[:id])
  end
  def find_user
    @user = User.find_by_login(params[:user_id], :include=>:events)
  end
end
