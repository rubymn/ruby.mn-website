class EventsController < ApplicationController
  before_filter :login_required
  before_filter :admin_required, :only=>:show
  before_filter :find_res, :res_matches_user, :except=>[:index, :create, :new]

  def index
    @events = Event.find(:all, :order=>'scheduled_time desc')
  end

  def create
    @event = current_user.events.create(params[:event])
    if @event.save
      redirect_to :action=>"index"
      Notifier.deliver_notify_event(@event)
    else
      render :template=>'events/new'
    end
  end

  def update
    @event = @res
    @event.update_attributes(params[:event])
    if @event.save
      redirect_to event_path(@event)
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
    u = current_user
    id=params[:id]
    evt = Event.find(id)
    if u.events.include? evt
      evt.destroy
      redirect_to :controller=>'welcome', :action=>'index'
    else
      bounce
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
    @event=@res
  end

  def show
    @event = @res
  end

  private
  def find_res
    @res = Event.find(params[:id]) if params[:id]
  end
end
