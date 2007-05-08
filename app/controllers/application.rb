# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base

  private


  def admin_required
    if current_user.admin?
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
      User.find(session[:uid]) if session[:uid]
  end

  def res_matches_user
    return true if @res.user_id==session[:uid] || current_user.admin?
    flash[:error]="Access Denied"
    session[:uid]=nil
    redirect_to :controller=>'user', :action=>'login'
    return false
  end

  def bounce
    flash[:error] = "Access Denied"
    session[:uid]=nil
    redirect_to :controller=>'user', :action=>'login'
    @current_user = nil
  end


end
