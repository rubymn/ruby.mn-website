#overriding from engine


class UserController  < ApplicationController
  before_filter :login_required,  :only=>[:list]

  def home
    if user?
      @fullname = "#{current_user.firstname} #{current_user.lastname}"
    else
      u = User.find(params[:user_id])
      key = params[:key]
      if User.find_by_security_key(key).id == u.id
        u.valid=1
        u.save!
        @fullname="#{u.firstname} #{u.lastname}"
      end

    end # this is a bit of a hack since the home action is used to verify user
        # keys, where noone is logged in. We should probably create a unique
        # 'validate_key' action instead.
  end

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

  # Register as a new user. Upon successful registration, the user will be sent to
  # "/user/login" to enter their details.
  def signup
    return if generate_blank
    params[:user].delete('form')
    params[:user].delete('verified') # you CANNOT pass this as part of the request
    @user = User.new(params[:user])
    begin
      User.transaction(@user) do
        @user.new_password = true
        unless LoginEngine.config(:use_email_notification) and LoginEngine.config(:confirm_account)
          @user.verified = 1
        end
        if @user.save!
          key = @user.generate_security_token
          url = url_for(:action => 'home', :user_id => @user.id, :key => key)
          flash[:notice] = 'Signup successful!'
          if LoginEngine.config(:use_email_notification) and LoginEngine.config(:confirm_account)
            UserNotify.deliver_signup(@user, params[:user][:password], url)
            flash[:notice] << ' Please check your registered email account to verify your account registration and continue with the login.'
          else
            flash[:notice] << ' Please log in.'
          end
          redirect_to :action => 'login'
        end
      end
    rescue Exception => e
      flash.now[:notice] = nil
      flash.now[:warning] = "Error creating account: #{e}"
      logger.error "Unable to send confirmation E-Mail:"
      logger.error e
    end
  end

end
