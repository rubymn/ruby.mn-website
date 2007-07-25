require File.dirname(__FILE__) + '/../test_helper'
require 'archive_controller'

# Re-raise errors caught by the controller.
class ArchiveController; def rescue_action(e) raise e end; end

class ArchiveControllerTest < Test::Unit::TestCase
  fixtures :list_mails, :users
  def setup
    @controller = ArchiveController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end


  def test_message
    login_as(:bob)
    post :message, :id=>list_mails(:list_mails_3285).id
    assert_response  :success
    assert assigns(:message)
    assert_template 'message'
  end

  def test_show
    login_as(:bob)
    get :show, :id=>list_mails(:list_mails_3285).id
    assert_response :success
    assert assigns(:message)
    assert_equal list_mails(:list_mails_3285), assigns(:message)
    assert_template 'show'
  end
end
