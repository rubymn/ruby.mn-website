gem 'recaptcha'
# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  include ReCaptcha::AppHelper


  def admin_required
    if current_user and current_user.admin?
      return true
    else
      bounce
      return false
    end
  end



  def login_required
    session['return-to']=request.request_uri
    if not session[:uid]
      bounce
      return false
    end
    return true
  end

  def current_user
    if not @cu
      @cu = User.find(session[:uid]) if session[:uid]
    end
    @cu
  end

  def res_matches_user
    @user = User.find_by_login(params[:user_id])
    return true if @user.id == session[:uid] || (current_user && current_user.admin?)
    bounce
    return false
  end

  def bounce
    flash[:error] = "Access Denied"
    session[:uid]=nil
    redirect_to new_session_path
    @current_user = nil
  end


end
