require 'test_helper'

class WelcomeControllerTest < ActionController::TestCase
  def test_works_logged_in
    u = login
    get :index
    assert_response :success
  end

  def test_no_jacket_required
    get :index
    assert_response :success
  end

  def test_lists_events
    Factory :event
    Factory :event
    get :index
    assert_response :success
    assert_equal 2, assigns(:events).size
    assigns(:events).each do|e|
      assert e.approved?
    end
  end

  def test_rss_feed
    get :index, :format => 'xml'
    assert_response :success
  end
end
