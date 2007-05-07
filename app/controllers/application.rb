# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base

  private
  def login_required
    session['return-to']=request.request_uri
    if not session[:uid]
      redirect_to :controller=>'user', :action=>'login'
    end
    return true
  end

  def current_user
    User.find(session[:uid]) if session[:uid]
  end

end
