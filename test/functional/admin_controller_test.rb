require File.dirname(__FILE__) + '/../test_helper'
require 'admin_controller'

# Re-raise errors caught by the controller.
class AdminController; def rescue_action(e) raise e end; end

class AdminControllerTest < Test::Unit::TestCase
  fixtures :users
  def setup
    @controller = AdminController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_admin_role_required
    login_as(:notadmin)
    get :index
    assert_response :redirect
    assert_redirected_to :controller=>'user', :action=>'login'
    assert_equal flash[:error], 'Access Denied (hoser).'
    assert_nil session[:uid]
  end

  def test_index
    login_as(:admin)
    get :index
    assert_response :success
    assert_template 'index'
    assert assigns(:events)
    assigns(:events).each do|e|
      assert !e.approved?
    end
  end

end
