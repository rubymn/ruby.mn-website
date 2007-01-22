# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base

  def login_required
    session['return-to']=request.request_uri
    if session[:user].nil?
      redirect_to :controller=>'user', :action=>'login'
    end
    return true
  end
  
end
