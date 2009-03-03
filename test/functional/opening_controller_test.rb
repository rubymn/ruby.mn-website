require File.dirname(__FILE__) + '/../test_helper'
require 'openings_controller'

# Re-raise errors caught by the controller.
class OpeningsController; def rescue_action(e) raise e end; end

class OpeningControllerTest < Test::Unit::TestCase
  fixtures :users, :openings
  def setup
    @controller = OpeningsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_new
    login_as(:bob)
    get :new
    assert assigns(:opening)
    assert_response :success
    assert_template 'opening_form'
  end

  def test_update
    login_as(:bob)
    put :update, :id=>openings(:first).id, :opening=>{:headline=>'feh'}
    assert_response :redirect 
    assert_redirected_to openings_path
    assert assigns(:opening)
    assert_equal assigns(:opening).headline, 'feh'
    assert !assigns(:opening).new_record?
  end

  def test_requires_login 
    get :index
    assert_bounced
  end

  def test_index
    @request.session[:uid] = users(:bob).id
    get :index
    assert_response :success
    assert_template 'index'
    assert assigns(:openings)
  end

  def test_create
    login_as(:bob)
    post :create, :opening=>{:body=>'foo', :headline=>'bar'}
    assert_response :redirect
    assert_redirected_to openings_path
  end
end
