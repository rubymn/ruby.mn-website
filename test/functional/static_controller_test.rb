require 'test_helper'

class StaticControllerTest < ActionController::TestCase
  should route(:get, '/sponsors').to(:controller => 'static', :action => 'sponsors')
  should route(:post, '/special-offers').to(:controller => 'static', :action => 'special_offers')
end
