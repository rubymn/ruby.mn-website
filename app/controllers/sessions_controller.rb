class SessionsController < ApplicationController
  def show
    bounce
  end

  def new
  end

  def destroy
    session[:uid] = nil
    redirect_to root_path, :notice => 'Logged Out'
  end

  def create
    u = User.authenticate(params[:login], params[:password])
    if u
      session[:uid] = u.id
      redirect_to root_path, :notice => u.admin? ? 'Admin Login Successful' : 'Login Successful'
    else
      redirect_to new_session_path, :alert => 'Login Unsuccessful'
    end
  end
end
