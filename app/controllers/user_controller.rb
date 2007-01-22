class UserController  < ApplicationController
  before_filter :login_required,  :only=>[:list]

  def do_change_password_for(user)
    begin
      User.transaction(user) do
        user.change_password(params[:user][:password], params[:user][:password_confirmation])
        user.save!
        flash[:notice] = "Password updated."
        return true
      end
    rescue
      flash[:warning] = "Password could not be changed at this time. Please retry. #{$!}"
    end
  end

  # Generate a template user for certain actions on get
  def generate_filled_in
    get_user_to_act_on
    case request.method
    when :get
      render
      return true
    end
    return false
  end

  # returns the user object this method should act upon; only really
  # exists for other engines operating on top of this one to redefine...
  def get_user_to_act_on
    user?
    @user=session[:user]
  end
  def change_password
    return if generate_filled_in
    if do_change_password_for(@user)
      session[:user]=nil
      redirect_to :controller=>"user", :action=>"login"
    end
  end
  def forgot_password
    # Always redirect if logged in
    if user?
      flash[:message] = 'You are currently logged in. You may change your password now.'
      redirect_to :action => 'change_password'
      return
    end

    # Render on :get and render
    return if generate_blank

    # Handle the :post
    if params[:user][:email].empty?
      flash.now[:warning] = 'Please enter a valid email address.'
    elsif (user = User.find_by_email(params[:user][:email])).nil?
      flash.now[:warning] = "We could not find a user with the email address #{params[:user][:email]}"
    else
      begin
        User.transaction(user) do
          key = user.generate_security_token
          url = url_for(:action => 'change_password', :user_id => user.id, :key => key)
          UserNotify.deliver_forgot_password(user, url)
          flash[:notice] = "Instructions on resetting your password have been emailed to #{params[:user][:email]}"
        end  
        unless user?
          redirect_to :action => 'login'
          return
        end
        redirect_back_or_default :action => 'home'
      rescue
        flash.now[:warning] = "Your password could not be emailed to #{params[:user][:email]}"
      end
    end
  end

  def validate
    t = params[:key]
    u = User.find_by_security_token(t)
    if u
      u.verified = true
      u.save!
      if session['return-to']
        redirect_to session['return-to']
      else
        redirect_to :action=>'index', :controller=>'welcome'
      end
    else
      redirect_to :action=>'login'
    end

  end

  def home
      @fullname = "#{current_user.firstname} #{current_user.lastname}"
  end

  def logout
    session[:user]=nil
    redirect_to :controller=>"welcome"
  end

  def login
    return if not params[:user]
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

  # Register as a new user. Upon successful registration, the user will be sent to
  # "/user/login" to enter their details.
  def signup
    if not params[:user]
      return
    end
    @user = User.new(params[:user])
        if @user.save
          key = @user.generate_security_token
          url = url_for(:action => 'home', :user_id => @user.id, :key => key)
          flash[:notice] = 'Signup successful!'
          SignupMailer.create_confirm(@user)
          SignupMailer.deliver_confirm(@user)
          flash[:notice] << ' Please check your registered email account to verify your account registration and continue with the login.'
        else
          flash[:notice] << ' Please log in.'
        end
        redirect_to :action => 'login'
  end

end
