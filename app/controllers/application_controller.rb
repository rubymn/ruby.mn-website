class ApplicationController < ActionController::Base
  protect_from_forgery

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
      unless @cu
        @cu = User.find(session[:uid]) if session[:uid]
      end
      @cu
    end
    helper_method :current_user

    def logged_in?
      !current_user.nil?
    end

    def bounce
      flash[:error] = "Access Denied"
      session[:uid] = nil
      redirect_to new_session_path
      @current_user = nil
    end
end
