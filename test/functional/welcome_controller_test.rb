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

  context "rss feed" do
    setup { get :index, :format => :xml }
    should respond_with(:success)
    should respond_with_content_type(:xml)
    should_not set_the_flash
  end
end
