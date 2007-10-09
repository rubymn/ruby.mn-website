ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'

class Test::Unit::TestCase
  # Transactional fixtures accelerate your tests by wrapping each test method
  # in a transaction that's rolled back on completion.  This ensures that the
  # test database remains unchanged so your fixtures don't have to be reloaded
  # between every test method.  Fewer database queries means faster tests.
  #
  # Read Mike Clark's excellent walkthrough at
  #   http://clarkware.com/cgi/blosxom/2005/10/24#Rails10FastTesting
  #
  # Every Active Record database supports transactions except MyISAM tables
  # in MySQL.  Turn off transactional fixtures in this case; however, if you
  # don't care one way or the other, switching from MyISAM to InnoDB tables
  # is recommended.
  self.use_transactional_fixtures = true

  # Instantiated fixtures are slow, but give you @david where otherwise you
  # would need people(:david).  If you don't want to migrate your existing
  # test cases which use the @david style and don't mind the speed hit (each
  # instantiated fixtures translates to a database query per test method),
  # then set this back to true.
  self.use_instantiated_fixtures  = false

  # Add more helper methods to be used by all tests here...
  def login_as(sym)
    @request.session[:uid]=users(sym).id
  end
  def assert_restful_routes(resource)
    "simple case route testing"
    assert_routing "/#{resource}", {:controller=>"#{resource}", :action=>'index'}
    assert_routing "/#{resource}/1", {:controller=>"#{resource}", :action=>'show', :id=>'1'}
    assert_routing "/#{resource}/1/edit", {:controller=>"#{resource}", :action=>'edit', :id=>'1'}
    assert_routing "/#{resource}/new", {:controller=>"#{resource}", :action=>'new'}
    assert_recognizes({:controller=>"#{resource}", :action=>'destroy', :id=>'1'}, {:path=>"/#{resource}/1", :method=>:delete})
    assert_recognizes({:controller=>"#{resource}", :action=>'update', :id=>'1'}, {:path=>"/#{resource}/1", :method=>:put})

    test_methods = ['test_destroy', 'test_update', 'test_edit', 'test_new', 'test_create', 'test_index', 'test_show']
    test_methods.delete_if  {|t|  self.methods.include?(t)}
    fail "You haven't tested all the routes. \nRemaining:\n\t#{test_methods.join("\n\t")}" if test_methods.size != 0
  end
  def assert_bounced
    assert_redirected_to new_session_path
    assert_nil session[:uid]
  end
end
