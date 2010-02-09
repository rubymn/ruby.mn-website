require 'test_helper'

class BearddexesControllerTest < ActionController::TestCase
  should_route :get, '/bearddex', :action => 'show'
  context "a show req" do
    setup {get :show}
    should_respond_with :success
    should_render_template 'show'
    should_assign_to :beardos do
      assert assigns(:beardos)
    end
  end
end
