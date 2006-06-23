# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
require 'login_engine'
class ApplicationController < ActionController::Base
  include LoginEngine
  helper :user
  model :user
  
end
