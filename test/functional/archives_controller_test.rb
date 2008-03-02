require File.dirname(__FILE__) + '/../test_helper'
require 'archives_controller'

# Re-raise errors caught by the controller.
class ArchivesController; def rescue_action(e) raise e end; end

class ArchivesControllerTest < Test::Unit::TestCase
  fixtures :list_mails, :users
  def setup
    @controller = ArchivesController.new
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

end
