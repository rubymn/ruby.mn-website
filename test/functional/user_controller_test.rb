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
    @request.session[:uid]=users(:bob).id
    get :logout
    assert_nil session[:uid]
    assert_response :redirect
    assert_redirected_to :controller=>'welcome'
  end
  def test_badpass
    post :login, 'user'=>{'login'=>'admin', 'password'=>'fstandard'}
    assert_response :success
    assert_equal "Login Unsuccessful", flash[:error]
    assert_template 'login'
  end
  def test_baduser
    post :login, 'user'=>{'login'=>'fadmin', 'password'=>'standard'}
    assert_response :success
    assert_equal "Login Unsuccessful", flash[:error]
    assert_template 'login'
  end
  def test_admin_login
    assert_not_nil users(:admin)
    assert_not_nil User.find_by_login('admin')
    post :login, 'user'=>{'login'=>'admin', 'password'=>'standard'}
    assert_response :redirect
    assert_redirected_to :controller=>'welcome', :action=>'index'
    assert_equal 'Admin Login Successful', flash[:notice]
  end

  def test_login
    assert_not_nil users(:bob)
    assert_not_nil User.find_by_login('existingbob')
    post :login, 'user'=>{'login'=>'existingbob', 'password'=>'standard'}
    assert_response :redirect
    assert_redirected_to :controller=>'welcome', :action=>'index'
    assert_equal flash[:notice], 'Login Successful'
  end



  def test_list_users
    get :list
    assert_response :redirect
    assert_redirected_to :action=>'login', :controller=>"user"
    @request.session[:uid]=users(:bob).id
    get :list
    assert_response :success
    assert assigns(:users)
  end

  def test_signup
    post :signup, {"user"=>{"password_confirmation"=>"standard", "lastname"=>"Looney", 
      "firstname"=>"MCClain", "login"=>"mogwai", "password"=>"standard", "email"=>"m@loonsoft.com"}}
      assert_response :redirect
      assert_nil flash[:warning]
    assert_equal "Signup successful! Please check your registered email account to verify your account registration and continue with the login.", flash[:notice]
    assert_nil flash[:warning]
    assert_not_nil User.find_by_login("mogwai")
    assert_response :redirect
    assert_redirected_to  :action=>'login'
  end

  def test_password_conf
    post :signup, "user"=>{"password_confirmation"=>"fu", "lastname"=>"looney", "firstname"=>"mcclain", "login"=>"mml", "password"=>"standard", "email"=>"m@loonsoft.com"} 

    assert_response :success
    assert_template 'signup'
    assert assigns(:user)
    assert_equal ["Password doesn't match confirmation"] ,assigns(:user).errors.each_full{}
  end
  def test_empty_pass
    post :signup, "user"=>{ "lastname"=>"looney", "firstname"=>"mcclain", "login"=>"mml",  "email"=>"m@loonsoft.com"} 

    assert_response :success
    assert_template 'signup'
    assert assigns(:user)
    assert_equal ["Password can't be blank"] ,assigns(:user).errors.each_full{}
  end

  def test_create
    post :signup, "user"=>{"password_confirmation"=>"standard", "lastname"=>"looney", "firstname"=>"mcclain", "login"=>"tutu", "password"=>"standard", "email"=>"m@loonsoft.com"} 
    assert_response :redirect
    assert_redirected_to :action=>'login'
    assert flash[:notice]
    u = User.find_by_login('tutu')
    assert_not_nil u
    u.reload
    assert !u.verified?
    u.verified = true
    u.save!
    u.reload
    u = User.find_by_login('tutu')
    assert_not_nil u
    assert u.verified?
    assert_not_nil u.salted_password
    assert_not_nil u.salt
  end

  def test_validate
    @request.session[:uid] = nil
    assert_not_nil User.find(130)
    assert !User.find(130).verified?
    get :validate, "key"=>"baf41cc616ee9185c1769fc864e4b308e0a26046"
    assert User.find(130).verified?
    assert_response :redirect
    assert_redirected_to :controller=>'welcome', :action=>'index'
  end

  def test_reset
    post :reset, :login=>'bob'
    assert_response :success
    assert_template 'reset'
  end

  def test_reset
    @request.session[:uid]=users(:bob).id
    post  :set_password, {"password"=>'test', "pass2"=>"not"}
    assert_response :redirect 
    assert_redirected_to :action=>'change_password'
    assert_not_nil flash[:error]
  end
end
