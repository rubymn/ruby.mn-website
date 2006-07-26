require File.dirname(__FILE__) + '/../test_helper'
require 'for_hire_controller'

# Re-raise errors caught by the controller.
class ForHireController; def rescue_action(e) raise e end; end

class ForHireControllerTest < Test::Unit::TestCase
  fixtures :users, :for_hires
  def setup
    @controller = ForHireController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
  def test_login_required
    get :index
    assert_response :redirect
    assert_redirected_to :controller=>'user', :action=>'login'

  end

  def test_get_with_id
    @request.session[:user]=users(:bob)
    get :edit, :id=>1
    assert_response :success
    assert assigns(:for_hire)
    assert_template 'for_hire_form'

  end

  # Replace this with your real tests.
  def test_index
    @request.session[:user]=users(:bob)
    get :index
    assert_response :success
    assert assigns(:for_hires)
    assert_template 'index'
  end

  def test_create_post
    @request.session[:user]=users(:bob)

    post :create, {:for_hire=>{:title=>'title', 
      :blurb=>'blurb', :email=>'email@email.com'}}
    assert_response :redirect
    assert_redirected_to :action=>'index'
    fh = ForHire.find_by_title 'title'
    assert_not_nil fh
    assert_equal users(:bob), fh.user
  end

  def test_create_get_noid
    @request.session[:user]=users(:bob)
    get :create
    assert_response :success
    assert_template 'for_hire_form'
  end

  def test_create_post_with_id
    @request.session[:user]=users(:bob)
    post :create, {:for_hire=>{:title=>'title', 
      :blurb=>'test', :email=>'email@email.com', :id=>'1'}}
    assert_response :redirect
    assert_redirected_to :action=>'index'
    assert ForHire.find(1).blurb='test'
  end

  def test_evil_edit
    @request.session[:user]=users(:bob)
    get :edit, :id=>2
    assert_response :redirect
    assert_redirected_to :controller=>'welcome', :action=>'index'
    assert_nil session[:user]
  end

  def test_evil_update
    @request.session[:user]=users(:bob)
    post :create, {:for_hire=>{:title=>'title', 
      :blurb=>'test', :email=>'email@email.com', :id=>'2'}}
    assert_response :redirect
    assert_redirected_to :controller=>'welcome', :action=>'index'
    assert_nil session[:user]

  end

  def test_destroy
    @request.session[:user]=users(:bob)
    get :destroy, :id=>1
    assert_response :redirect
    assert_redirected_to :action=>'index'
    begin
      ForHire.find(1)
      fail "shouldn't be able to find deleted item"
    rescue
    end
  end

  def test_evil_destroy
    @request.session[:user]=users(:bob)
    get :destroy, :id=>2
    assert_response :redirect
    assert_redirected_to :controller=>'welcome', :action=>'index'
    assert_nil session[:user]
    assert ForHire.find(2)
  end
end
