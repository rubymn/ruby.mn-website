class OpeningsController < ApplicationController
  before_filter :login_required

  def index
    @openings = Opening.includes(:user).order('created_at DESC').page(params[:page])
  end

  def new
    @opening = Opening.new
  end

  def update
    @opening = Opening.find(params[:id])
    if @opening.update_attributes params[:opening]
      redirect_to openings_path, :notice => "Event created, admin notified."
    else
      render :action => :edit
    end
  end

  def create
    @opening      = Opening.new(params[:opening])
    @opening.user = current_user
    if @opening.save
      redirect_to openings_path, :notice => "Opening Created. Thanks."
    else
      render :action => :new
    end
  end

  def edit
    id = params[:id]
    if request.get? and @opening = Opening.find(id)
      @id = id
      if @opening.user != current_user
        session[:uid] = nil
        redirect_to root_path
      end
    end
  end

  def destroy
    if current_user && current_user.admin?
      Opening.destroy(params[:id])
    else
      current_user.openings.find(params[:id]).destroy
    end

    redirect_to openings_path, :notice => "Deleted opening."
  end
end
