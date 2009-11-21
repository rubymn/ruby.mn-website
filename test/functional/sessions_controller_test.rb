require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  def test_show
    get :show
    assert_bounced
  end

  def test_new
    assert_routing '/session/new', :action=>'new', :controller=>'sessions'
    get :new
    assert_response :success
    assert_template 'new'
    assert_nil session[:uid]
    assert_nil flash[:error]
  end

  def test_create
    u = Factory.create(:user)
    User.expects(:authenticate).with(u.login, u.password).returns(u)
    post :create, :password=>u.password, :login=>u.login
    assert_response :redirect
    assert_redirected_to :controller=>'welcome', :action=>'index'
    assert_equal session[:uid], u.id
  end

  def test_destroy
    delete :destroy
    assert_response :redirect
    assert_redirected_to :controller=>'welcome', :action=>'index'
    assert_nil session[:uid]
    assert_equal "Logged Out", flash[:info]
  end
end
