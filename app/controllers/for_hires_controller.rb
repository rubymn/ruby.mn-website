class ForHiresController < ApplicationController
  before_filter :login_required, :except => :index
  before_filter :bounce_foreign_access, :only => [:edit, :update, :destroy]

  def index
    @for_hires = ForHire.all :order => :title
  end

  def new
    @for_hire = current_user.build_for_hire
  end

  def show
    redirect_to :action => :index
  end

  def create
    @for_hire = current_user.build_for_hire(params[:for_hire])

    if @for_hire.save
      flash[:alert] = "created for hire entry"
      redirect_to for_hires_path
    else
      flash.now[:error] = "error creating for hire profile"
      render :action => :new
    end
  end

  def edit
    @for_hire = current_user.for_hire
  end

  def update 
    @for_hire = current_user.for_hire
    if @for_hire && @for_hire.update_attributes(params[:for_hire])
      flash[:alert] = "updated for hire entry"
      redirect_to for_hires_path
    else
      render :action => :edit
    end
  end

  def destroy
    @for_hire = current_user.for_hire
    if @for_hire && @for_hire.destroy
      flash[:alert] = "deleted your for hire entry"
      redirect_to :action => :index
    else
      flash[:error] = "error deleting your for hire profile"
      redirect_to for_hires_path
    end
  end


  private

    def bounce_foreign_access
      if params[:id]
        session[:uid] = nil
        redirect_to root_path
      end
    end

end
