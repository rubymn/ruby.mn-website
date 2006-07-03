#overriding from engine


class UserController  < ApplicationController
  before_filter :login_required,  :only=>[:list]

  def logout
    session[:user]=nil
    redirect_to :controller=>"welcome"
  end

  def login
    return if generate_blank
    @user = User.new(params[:user]) # what does this achieve?
    if session[:user] = User.authenticate(params[:user][:login], params[:user][:password])
      flash[:notice] = 'Login successful'
      redirect_to :controller => 'welcome'
    else
      @login = params[:user][:login]
      flash.now[:warning] = 'Login unsuccessful'
    end
  end
  # Generate a template user for certain actions on get
  def generate_blank
    case request.method
    when :get
      @user = User.new
      render
      return true
    end
    return false
  end


  def list
    @users=User.find :all, :order=>'firstname'


  end

end
