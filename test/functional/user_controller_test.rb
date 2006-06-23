require File.dirname(__FILE__) + '/../test_helper'
require 'user_controller'

# Re-raise errors caught by the controller.
class UserController; def rescue_action(e) raise e end; end

class UserControllerTest < Test::Unit::TestCase
  fixtures :users
  def setup
    @controller = UserController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_overridden_behavior
    @request.session[:user]=users(:bob)
    get :logout
    assert_nil session[:user]
    assert_response :redirect
    assert_redirected_to :controller=>'welcome'

  end


  def test_list_users
    get :list
    assert_response :redirect
    assert_redirected_to :action=>'login', :controller=>"user"
    @request.session[:user]=users(:bob)
    get :list
    assert assigns(:users)
  end

end
