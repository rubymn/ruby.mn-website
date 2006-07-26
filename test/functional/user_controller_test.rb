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

  def test_signup
    post :signup, {"user"=>{"password_confirmation"=>"standard", "lastname"=>"Looney", 
      "firstname"=>"MCClain", "login"=>"mogwai", "password"=>"standard", "email"=>"m@loonsof
      t.com"}, "commit"=>"Signup", "action"=>"signup", "controller"=>"user"}
    assert_equal "Signup successful! Please check your registered email account to verify your account registration and continue with the login.", flash[:notice]
    assert_nil flash[:warning]
    assert_not_nil User.find_by_login("mogwai")
    assert_response :redirect
    assert_redirected_to  :action=>'login'
  end

  def test_home_verify
#http://www.ruby.mn/user/home?key=baf41cc616ee9185c1769fc864e4b308e0a26046&user_id=130
    assert_not_nil User.find(130)
    assert !User.find(130).verified?
    get :home, {"key"=>"baf41cc616ee9185c1769fc864e4b308e0a26046", "user_id"=>"130"}
    assert User.find(130).verified?
  end
end
