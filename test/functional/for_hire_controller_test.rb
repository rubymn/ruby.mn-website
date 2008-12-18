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
    @u = users(:bob)
    @fh1 = for_hires(:first)
    @fh2 = for_hires(:second)
    @request.session[:uid]=@u.id
  end
  def test_login_not_required
    @request.session[:uid]=nil
    get :index
    assert_response :success
    assert_template 'index'

  end

  def test_get_with_id
    get :edit, :id=>@fh1.id
    assert_response :success
    assert assigns(:for_hire)
    assert_equal @fh1, assigns(:for_hire)
    assert_template 'for_hire_form'

  end

  # Replace this with your real tests.
  def test_index
    get :index
    assert_response :success
    assert assigns(:for_hires)
    assert_template 'index'
  end

  def test_create_post
    @request.session[:uid]=@u.id

    post :create, {:for_hire=>{:title=>'title', 
      :blurb=>'blurb', :email=>'email@email.com'}}
    assert_response :redirect
    assert_redirected_to :action=>'index'
    fh = ForHire.find_by_title 'title'
    assert_not_nil fh
    assert_equal @u, fh.user
  end

  def test_create_get_noid
    get :create
    assert_response :success
    assert_template 'for_hire_form'
  end

  def test_create_post_with_id
    post :create, {:for_hire=>{:title=>'title', 
      :blurb=>'test', :email=>'email@email.com', :id=>@fh1.id}}
    assert_response :redirect
    assert_redirected_to :action=>'index'
    assert @fh1.reload.blurb='test'
  end

  def test_evil_edit
    get :edit, :id=>@fh2.id
    assert_response :redirect
    assert_redirected_to :controller=>'welcome', :action=>'index'
    assert_nil session[:uid]
  end

  def test_evil_update
    post :create, {:for_hire=>{:title=>'title', 
      :blurb=>'test', :email=>'email@email.com', :id=>@fh1.id}}
    assert_response :redirect
    assert_redirected_to :controller=>'welcome', :action=>'index'
    assert_nil session[:uid]

  end

  def test_destroy
    get :destroy, :id=>@fh1.id
    assert_response :redirect
    assert_redirected_to :action=>'index'
    begin
      ForHire.find(1)
      fail "shouldn't be able to find deleted item"
    rescue
    end
  end

  def test_evil_destroy
    fh = for_hires(:second)
    get :destroy, :id=>fh.id
    assert_response :redirect
    assert_redirected_to :controller=>'welcome', :action=>'index'
    assert_nil session[:uid]
    assert ForHire.find(fh.id)
  end
end
