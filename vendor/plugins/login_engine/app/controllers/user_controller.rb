class UserController < ApplicationController
  model   :user

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
