class UserController  < ApplicationController
  before_filter :login_required,  :only=>[:list, :set_password]

  def change_password
    if (u = User.find_by_security_token(params[:key]))
      session[:uid]=u.id
    else
      redirect_to :action=> 'login'
    end
  end

  def set_password
    if params[:password] == params[:pass2]
    current_user.password = params[:password]
    current_user.crypt_new_password
    current_user.reload
    redirect_to :controller=>'welcome', :action=>'index'
    else
      flash[:error]="password confirmation mismatch"
      redirect_to :action=>'change_password'
    end
  end

  def forgot_password
    # Always redirect if logged in
    if session[:user] and request.get?
      flash[:message] = 'You are currently logged in. You may change your password now.'
      render :action=> "change_password"
      return
    else
      render :action=>"forgot_form"
    end
  end

  def reset
    if u= User.find_by_login(params[:login])
      u.generate_security_token
      SignupMailer.deliver_pass_inst(u)
    end
  end

  def validate
    t = params[:key]
    u = User.find_by_security_token(t)
    if u
      u.verified = true
      u.save!
      session[:uid]=u.id
      redirect_to :action=>'index', :controller=>'welcome'
    else
      redirect_to :action=>'login'
    end

  end

  def home
    @fullname = "#{current_user.firstname} #{current_user.lastname}"
  end

  def logout
    session[:uid]=nil
    redirect_to :controller=>"welcome"
  end

  def login
    return if not params[:user]
    u=User.authenticate(params[:user][:login], params[:user][:password])
    if u
      session[:uid]=u.id
      flash[:notice] = u.admin? ?  'Admin Login Successful' : 'Login Successful'
      redirect_to :controller => 'welcome', :action=>'index'
    else
      flash[:error] = 'Login Unsuccessful'
    end
  end


  def list
    @users=User.find :all, :order=>'firstname', :conditions=>'verified !=0'
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
      redirect_to :action => 'login'
    else
      render :action=>'signup'
    end
  end

end
