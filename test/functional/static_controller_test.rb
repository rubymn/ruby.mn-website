require 'test_helper'

class StaticControllerTest < ActionController::TestCase
  should_route :get, '/sponsors', :action => 'sponsors', :controller => 'static'
  should_route :post, '/special-offers', :action => 'special_offers', :controller => 'static'
  
end
