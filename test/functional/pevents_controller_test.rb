require File.dirname(__FILE__) + '/../test_helper'
require 'pevents_controller'

# Re-raise errors caught by the controller.
class PeventsController; def rescue_action(e) raise e end; end

class PeventsControllerTest < Test::Unit::TestCase
  fixtures :events, :users
  def setup
    @controller = PeventsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_show
    get :show,  :id=>events(:first).id
    assert_response :success
    assert_template 'show'
    assert assigns(:event)
    assert_equal events(:first), assigns(:event)
  end

  def test_rss
    get :rss, :format=>'rss'
    assert_response :success
    assert_match /http:\/\/test.host\/pevents\/1/, @response.body

  end
end

