class UsersController  < ApplicationController
  before_filter :login_required,  :only=>[:index, :set_password]
  before_filter :admin_required, :only=>:destroy

  def change_password
    if (u = User.find_by_security_token(params[:key]))
      session[:uid]=u.id
    else
      redirect_to new_session_path
    end
  end

  def set_password
    if params[:password] == params[:pass2]
    current_user.password = params[:password]
    current_user.crypt_new_password
    current_user.reload
    flash[:info]="Password successfully changed"
    redirect_to :controller=>'welcome', :action=>'index'
    else
      flash[:error]="Password Confirmation mismatch"
      render :template=>'users/change_password'
    end
  end

  def forgot_password
    # Always redirect if logged in
    if session[:uid] and request.get?
      flash[:message] = 'You are currently logged in. You may change your password now.'
      render :template=> "users/change_password"
      return
    else
      render :template=>"users/forgot_form"
    end
  end

  def reset
    if u= User.find_by_login(params[:login])
      u.generate_security_token
      SignupMailer.deliver_pass_inst(u)
    end
  end

  def validate
    u = User.find_by_security_token(params[:key])
    if u
      u.verified = true
      u.save!
      session[:uid]=u.id
      flash[:notice]='Your account has been confirmed. Thanks!'
      redirect_to :action=>'index', :controller=>'welcome'
    else
      redirect_to new_session_path
    end

  end


  def index
    @users=User.find :all, :order=>'firstname', :conditions=>'verified !=0', :select=>'firstname, lastname, id,email'
  end

  # Register as a new user. Upon successful registration, the user will be sent to
  # "/user/login" to enter their details.
  def new
    @user = User.new
  end

  def create
    User.transaction do
      @user = User.new(params[:user])
      if ( validate_recap(params, @user.errors) || RAILS_ENV!='production') && @user.save
        key = @user.generate_security_token
        SignupMailer.deliver_confirm(@user)
        flash[:notice] = ' Please check your registered email account to verify your account.'
        redirect_to :controller=>'welcome', :action=>'index'
      else
        render :action=>:new
      end
    end
  end

end
