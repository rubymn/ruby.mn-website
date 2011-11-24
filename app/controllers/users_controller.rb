class UsersController  < ApplicationController
  before_filter :login_required,  :only => [:index, :set_password, :edit, :update]
  before_filter :admin_required,  :only => :destroy

  def change_password
    if (u = User.find_by_security_token(params[:key]))
      session[:uid] = u.id
    else
      redirect_to new_session_path
    end
  end

  def set_password
    if params[:password] == params[:pass2]
      current_user.password = params[:password]
      current_user.crypt_new_password
      current_user.reload
      redirect_to root_path, :notice => "Password successfully changed"
    else
      flash[:alert] = "Password Confirmation mismatch"
      render :template => 'users/change_password'
    end
  end

  def forgot_password
    # Always redirect if logged in
    if session[:uid] and request.get?
      flash.now[:notice] = 'You are currently logged in. You may change your password now.'
      render :template => "users/change_password"
    else
      render :template => "users/forgot_form"
    end
  end

  def reset
    u = User.first :conditions => ['email=? or login=?', params[:login], params[:login]]
    if u
      u.generate_security_token
      SignupMailer.pass_inst(u).deliver
      flash.now[:notice] = 'Sweet. We sent the mail!'
    else
      flash.now[:alert] = "Couldn't find that guy, guy."
      render :template => 'users/forgot_form'
    end
  end

  def validate
    u = User.find_by_security_token(params[:key])
    if u
      u.verified = 1
      u.save!
      session[:uid] = u.id
      redirect_to root_path, :notice => 'Your account has been confirmed. Thanks!'
    else
      redirect_to new_session_path
    end
  end

  def index
    @users = User.where('verified != 0').select('firstname, lastname, id, email, gravatar_email').order('LOWER(firstname), lastname')
  end

  # Register as a new user. Upon successful registration, the user will be sent to "/user/login" to enter their details.
  def new
    @user = User.new
  end

  def create
    User.transaction do
      @user = User.new(params[:user])
      if verify_recaptcha(:model => @user, :message => "Problem with captcha") && @user.save
        key = @user.generate_security_token
        SignupMailer.confirm(@user).deliver
        redirect_to root_path, :notice => 'Please check your registered email account to verify your account.'
      else
        render :action => :new
      end
    end
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if params[:user].present? && @user.update_attributes(:firstname => params[:user][:firstname], :lastname => params[:user][:lastname], :email => params[:user][:email])
      redirect_to edit_user_path(@user), :notice => "User account updated successfully."
    else
      render :action => :edit
    end
  end
end
