require 'test_helper'
class OpeningsControllerTest < ActionController::TestCase

  def test_new
    login
    get :new
    assert assigns(:opening)
    assert_response :success
    assert_template 'opening_form'
  end

  def test_update
    login
    o = Factory.create(:opening)

    put :update, :id=>o.id, :opening=>{:headline=>'feh'}
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
    login
    get :index
    assert_response :success
    assert_template 'index'
    assert assigns(:openings)
  end

  def test_create
    login
    post :create, :opening=>{:body=>'foo', :headline=>'bar'}
    assert_response :redirect
    assert_redirected_to openings_path
  end
end
