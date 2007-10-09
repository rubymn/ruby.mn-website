require File.dirname(__FILE__) + '/../test_helper'
require 'welcome_controller'

# Re-raise errors caught by the controller.
class WelcomeController; def rescue_action(e) raise e end; end

class WelcomeControllerTest < Test::Unit::TestCase
  def setup
    @controller = WelcomeController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
  
  fixtures :events

  def test_no_jacket_required
    get :index
    assert_response :success
  end
  
  def test_lists_events
    get :index
    assert_response :success
    assert_equal 2,  assigns(:events).size()
    assigns(:events).each do|e|
      assert e.approved?
    end
  end

  def test_rss_feed
    get :index, :format=>'xml'
    assert_response :success
  end

end
