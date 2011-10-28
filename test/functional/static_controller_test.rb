require 'test_helper'

class StaticControllerTest < ActionController::TestCase
  should route(:get, '/sponsors').to(:controller => 'static', :action => 'sponsors')
  should route(:post, '/special-offers').to(:controller => 'static', :action => 'special_offers')
  
  context "get to sponsors" do
    setup { get :sponsors }
    
    should respond_with(:success)
    should render_template(:sponsors)
    should_not set_the_flash
  end

  context "get to special_offers" do
    setup { get :special_offers }
    
    should respond_with(:success)
    should render_template(:special_offers)
    should_not set_the_flash
  end
end
