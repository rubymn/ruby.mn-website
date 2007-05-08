class SessionController < ApplicationController
  def show
    bounce
  end
  def index
    bounce
  end
  def new
  end
  def destroy
    flash[:info]='Logged Out'
    session[:uid]=nil
    redirect_to :controller=>'welcome', :action=>'index'
  end
  def create
    u=User.authenticate(params[:login], params[:password])
    if u
      session[:uid]=u.id
      flash[:notice] = u.admin? ?  'Admin Login Successful' : 'Login Successful'
      redirect_to :controller => 'welcome', :action=>'index'
    else
      flash[:error] = 'Login Unsuccessful'
      render :template=>'session/new'
    end
  end

end
