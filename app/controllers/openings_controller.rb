class OpeningsController < ApplicationController
  before_filter :login_required
  def index
    @openings = Opening.find(:all, :order=>'created_at desc')
  end

  def new
    @opening = Opening.new
    render :action=>'opening_form'
  end

  def update
    @opening = Opening.find(params[:id])
    if @opening.update_attributes params[:opening]
      flash.now[:notice]="Event created, admin notified."
      redirect_to :action=>'index'
    else
      render :action=>'opening_form'
    end
  end

  def create
    @opening = Opening.new params[:opening]
    @opening.user=current_user
    if @opening.save
      flash.now[:info]="Opening Created. Thanks."
      redirect_to :action=>'index'
    else
      render :action=>'opening_form'
    end
  end

  def edit
    id = params[:id]
    if request.get? and @opening=Opening.find(id)
      @id=id
      if @opening.user == current_user
        render :action=> 'opening_form'
      else
        session[:uid] = nil
        redirect_to :controller=>'welcome'
      end
    end
  end
  def destroy
    u = current_user
    id=params[:id]
    evt = Opening.find(id)
    if u.openings.include? evt
      evt.destroy
      redirect_to :action=>'index'
    else
      session[:uid]=nil
      redirect_to :controller=>"welcome", :action=>'index'
    end

  end

end
