require 'test_helper'

class SponsorsControllerTest < ActionController::TestCase
  should route(:get, '/sponsors').to(:action => 'index')

end

=begin
class StaticControllerTest < ActionController::TestCase
  should route(:get, '/sponsors').to(:controller => 'static', :action => 'sponsors')
  
  context "get to sponsors" do
    setup { get :sponsors }
    
    should respond_with(:success)
    should render_template(:sponsors)
    should_not set_the_flash
  end

end
=end
