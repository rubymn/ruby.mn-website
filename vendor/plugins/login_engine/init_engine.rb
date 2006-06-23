# load up all the required files we need...

require 'login_engine'

# TODO: why do I have to include these here, when including them in login_engine.rb should be sufficient?
require 'authenticated_user'
require 'authenticated_system'

#ApplicationController.send(:include, LoginEngine)
#ApplicationHelper.send(:include, LoginEngine)