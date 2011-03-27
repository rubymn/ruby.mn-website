class ForHiresController < ApplicationController
  before_filter :login_required, :except=>[:index]

  def index
    @for_hires = ForHire.find :all, :order=>'title'
  end

  def new
    @for_hire = current_user.build_for_hire
    render :template => 'for_hires/for_hire_form'
  end

  def create
    @for_hire = current_user.build_for_hire(params[:for_hire])

    if @for_hire.save
      flash[:success]="created for hire profile"
      # redirect_to user_for_hire_path(current_user)
      redirect_to for_hires_path
    else
      flash[:error]="error creating for hire profile"
      render :template=>'for_hires/for_hire_form'
    end
  end

  def destroy
    fh = ForHire.find(params[:id])
    if fh.user == current_user
      fh.destroy
      redirect_to :action=>'index'
    else
      session[:uid] = nil;
      redirect_to root_path
    end
  end


  def edit
    @for_hire=current_user.for_hire
    render :action=>'for_hire_form'

  end

  def update 
    @for_hire = current_user.for_hire
    if @for_hire.update_attributes params['for_hire']
      redirect_to user_for_hire_path(current_user)
    else
      render :template=> 'for_hires/for_hire_form'
    end
  end
end
