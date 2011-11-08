require 'test_helper'

class AdminControllerTest < ActionController::TestCase
  
  def test_admin_approve
    u = login(:role => 'admin')
    assert u.admin?
    e = Factory.create(:event, :approved => false, :user_id => u.id)
    assert !e.approved?
    assert_equal e.reload.user, u
    get :approve, :id => e.id, :user_id => e.user.id
    assert_response :redirect
    assert_redirected_to :controller => :admin, :action => :index
    e.reload
    assert e.approved?
    assert_equal flash[:notice], 'Event Approved'
  end

  def test_admin_role_required
    u = login
    get :index
    assert_response :redirect
    assert_redirected_to new_session_path
    assert_equal flash[:error], 'Access Denied'
    assert_nil session[:uid]
  end

  def test_index
    u = login(:role => 'admin')
    e = Factory.create(:event)
    e.user=u
    e.save
    get :index
    assert_response :success
    assert_template :index
    assert assigns(:events)
    assigns(:events).each do |e|
      assert !e.approved?
    end
  end
end
