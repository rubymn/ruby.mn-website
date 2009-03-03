require File.dirname(__FILE__) + '/../test_helper'
require 'users_controller'

# Re-raise errors caught by the controller.
class UsersController; def rescue_action(e) raise e end; end

class UsersControllerTest < Test::Unit::TestCase
  fixtures :users
  def setup
    @controller = UsersController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_restful
    assert_restful_routes(:users)
  end
  def test_new
    get :new
    assert_response :success
    assert_template 'new'
    assert assigns(:user)
    assert assigns(:user).new_record?
  end


  def test_destroy
  end
  def test_index
    get :index
    assert_bounced
    login_as(:bob)
    get :index
    assert_response :success
    assert assigns(:users)
  end

  def test_create
    post :create, {"user"=>{"password_confirmation"=>"standard", "lastname"=>"Looney", 
    "firstname"=>"MCClain", "login"=>"mogwai", "password"=>"standard", "email"=>"m@loonsoft.com"}}
    assert_response :redirect
    assert_redirected_to  :controller=>'welcome', :action=>'index'
    assert_nil flash[:warning]
    assert_equal "Signup successful! Please check your registered email account to verify your account.", flash[:notice]
    assert_nil flash[:warning]
    assert assigns(:user)
    assert_response :redirect
  end

  def test_password_conf
    post :create, "user"=>{"password_confirmation"=>"fu", "lastname"=>"looney", "firstname"=>"mcclain", "login"=>"mml", "password"=>"standard", "email"=>"m@loonsoft.com"} , :recatcha_challenge_field=>'foo', :recaptcha_response_field=>'foo'

    assert_response :success
    assert_template 'users/new'
    assert assigns(:user)
    assert_equal ["Password doesn't match confirmation"] ,assigns(:user).errors.each_full{}
  end
  def test_empty_pass
    post :create, "user"=>{ "lastname"=>"looney", "firstname"=>"mcclain", "login"=>"mml",  "email"=>"m@loonsoft.com"} 

    assert_response :success
    assert_template 'new'
    assert assigns(:user)
    assert_equal ["Password can't be blank"] ,assigns(:user).errors.each_full{}
  end

  def test_update;end
  def test_edit;end
  def test_show;end

  def test_create2
    post :create, "user"=>{"password_confirmation"=>"standard", "lastname"=>"looney", "firstname"=>"mcclain", "login"=>"tutu", "password"=>"standard", "email"=>"m@loonsoft.com"} 
    assert_response :redirect
    assert_redirected_to :controller=>'welcome', :action=>'index'
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
    u = users(:testyttest)
    assert !User.find(u.id).verified?
    get :validate, "key"=>"baf41cc616ee9185c1769fc864e4b308e0a26046"
    assert u.reload.verified?
    assert_response :redirect
    assert_redirected_to :controller=>'welcome', :action=>'index'
  end

end
