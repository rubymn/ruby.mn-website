class ForHiresController < ApplicationController
  before_filter :login_required, :except => :index
  before_filter :bounce_foreign_access, :only => [:edit, :update, :destroy]

  def index
    @for_hires = ForHire.order(:title)
  end

  def new
    @for_hire = current_user.build_for_hire
  end

  def show
    redirect_to for_hires_path
  end

  def create
    @for_hire = current_user.build_for_hire(params[:for_hire])

    if @for_hire.save
      flash[:notice] = "Created for hire entry."
      redirect_to for_hires_path
    else
      flash.now[:error] = "Error creating for hire profile."
      render :action => :new
    end
  end

  def edit
    @for_hire = current_user.for_hire
  end

  def update 
    @for_hire = current_user.for_hire
    if @for_hire && @for_hire.update_attributes(params[:for_hire])
      redirect_to for_hires_path, :notice => "Updated for hire entry."
    else
      render :action => :edit
    end
  end

  def destroy
    @for_hire = current_user.for_hire
    if @for_hire && @for_hire.destroy
      flash[:notice] = "Deleted your for hire entry."
    else
      flash[:error] = "Error deleting your for hire profile."
    end

    redirect_to for_hires_path
  end


  private

    def bounce_foreign_access
      if params[:id]
        session[:uid] = nil
        redirect_to root_path
      end
    end
end
