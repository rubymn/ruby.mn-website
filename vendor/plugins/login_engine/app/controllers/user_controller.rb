class UserController < ApplicationController
  model   :user
  before_filter :login_required, :only=>[:list]

  # Override this function in your own application to define a custom home action.
  def home
    if request.get? and params[:key]
      session[:user]=nil
      session[:user]=User.find_by_security_token(params[:key])
      if session[:user]
      session[:user].verified=true
      session[:user].save!
      end
    end

    if session[:user]
      @fullname = "#{current_user.firstname} #{current_user.lastname}"
    else
      @fullname = "Not logged in..."
    end # this is a bit of a hack since the home action is used to verify user
        # keys, where noone is logged in. We should probably create a unique
        # 'validate_key' action instead.
  end

  # The action used to log a user in. If the user was redirected to the login page
  # by the login_required method, they should be sent back to the page they were
  # trying to access. If not, they will be sent to "/user/home".
  def login
    return if generate_blank
    @user = User.new(params[:user])
    if session[:user] = User.authenticate(params[:user][:login], params[:user][:password])
      session[:user].logged_in_at = Time.now
      session[:user].save
      flash[:notice] = 'Login successful'
      redirect_to_stored_or_default :action => 'home'
    else
      @login = params[:user][:login]
      flash.now[:warning] = 'Login unsuccessful'
    end
  end

  def list
    @users=User.find(:all, :order=>'firstname')
  end

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
        if @user.save
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
      flash.now[:warning] = 'Error creating account: confirmation email not sent'
      logger.error "Unable to send confirmation E-Mail:"
      logger.error e
    end
  end



  def logout
    session[:user] = nil
    redirect_to :action => 'login'
  end

  def change_password
    return if generate_filled_in
    if do_change_password_for(@user)
      session[:user]=nil
      redirect_to :controller=>"user", :action=>"login"
    end
  end

  protected
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
    
  public



  def edit
    return if generate_filled_in
    do_edit_user(@user)
  end
  
  protected
    def do_edit_user(user)
      begin
        User.transaction(user) do
          user.attributes = params[:user].delete_if { |k,v| not LoginEngine.config(:changeable_fields).include?(k) }
          if user.save
            flash[:notice] = "User details updated"
          else
            flash[:warning] = "Details could not be updated! Please retry."
          end
        end
      rescue
        flash.now[:warning] = "Error updating user details. Please try again later."
      end
    end
  
  public

  def delete
    get_user_to_act_on
    if do_delete_user(@user)
      logout
    else
      redirect_back_or_default :action => 'home'
    end    
  end
  
  protected
    def do_delete_user(user)
      begin
        if LoginEngine.config(:delayed_delete)
          User.transaction(user) do
            key = user.set_delete_after
            if LoginEngine.config(:use_email_notification)
              url = url_for(:action => 'restore_deleted', :user_id => user.id, :key => key)
              UserNotify.deliver_pending_delete(user, url)
            end
          end
        else
          destroy(@user)
        end
        return true
      rescue
        if LoginEngine.config(:use_email_notification)
          flash.now[:warning] = 'The delete instructions were not sent. Please try again later.'
        else
          flash.now[:notice] = 'The account has been scheduled for deletion. It will be removed in #{LoginEngine.config(:delayed_delete_days)} days.'
        end
        return false
      end
    end
    
  public

  def restore_deleted
    get_user_to_act_on
    @user.deleted = 0
    if not @user.save
      flash.now[:warning] = "The account for #{@user['login']} was not restored. Please try the link again."
      redirect_to :action => 'login'
    else
      redirect_to :action => 'home'
    end
  end

  protected

  def destroy(user)
    UserNotify.deliver_delete(user) if LoginEngine.config(:use_email_notification)
    flash[:notice] = "The account for #{user['login']} was successfully deleted."
    user.destroy()
  end

  def protect?(action)
    if ['login', 'signup', 'forgot_password'].include?(action)
      return false
    else
      return true
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
end
