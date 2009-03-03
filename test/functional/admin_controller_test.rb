require File.dirname(__FILE__) + '/../test_helper'
require 'admin_controller'

# Re-raise errors caught by the controller.
class AdminController; def rescue_action(e) raise e end; end

class AdminControllerTest < Test::Unit::TestCase
  fixtures :users, :events
  def setup
    @controller = AdminController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
  def test_admin_approve
    login_as(:admin)
    assert !events(:notapproved).approved?
    get :approve, :id=>events(:notapproved).id, :user_id=>users(:existingbob).login
    assert_response :redirect
    assert_redirected_to :controller=>'admin', :action=>'index'
    events(:notapproved).reload
    assert events(:notapproved).approved?
    assert_equal flash[:info], 'Event Approved'
  end

  def test_admin_role_required
    login_as(:notadmin)
    get :index
    assert_response :redirect
    assert_redirected_to new_session_path
    assert_equal flash[:error], 'Access Denied (hoser).'
    assert_nil session[:uid]
  end

  def test_index
    login_as(:admin)
    get :index
    assert_response :success
    assert_template 'index'
    assert assigns(:events)
    assigns(:events).each do|e|
      assert !e.approved?
    end
  end

end
