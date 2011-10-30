class OpeningsController < ApplicationController
  before_filter :login_required

  def index
    @openings = Opening.all :order => 'created_at DESC'
  end

  def new
    @opening = Opening.new
  end

  def update
    @opening = Opening.find(params[:id])
    if @opening.update_attributes params[:opening]
      flash.now[:notice] = "Event created, admin notified."
      redirect_to openings_path
    else
      render :action => :edit
    end
  end

  def create
    @opening = Opening.new(params[:opening])
    @opening.user=current_user
    if @opening.save
      flash[:notice] = "Opening Created. Thanks."
      redirect_to openings_path
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
    flash[:notice] = "Deleted opening."
    redirect_to openings_path
  end
end
