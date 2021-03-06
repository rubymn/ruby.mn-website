class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :logged_in?

  protected

    def admin_required
      if current_user and current_user.admin?
        return true
      else
        bounce
        return false
      end
    end

    def login_required
      session['return-to'] = request.fullpath
      if not session[:uid]
        bounce
        return false
      end
      return true
    end

    def current_user
      begin
        @current_user ||= User.find(session[:uid]) if session[:uid]
      rescue Exception => e
        session[:uid] = nil unless @current_user
      end
    end
    helper_method :current_user

    def logged_in?
      !current_user.nil?
    end

    def bounce
      session[:uid] = nil
      redirect_to new_session_path, :alert => "Access Denied"
      @current_user = nil
    end
end
