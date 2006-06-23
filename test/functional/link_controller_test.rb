require File.dirname(__FILE__) + '/../test_helper'
require 'link_controller'

# Re-raise errors caught by the controller.
class LinkController; def rescue_action(e) raise e end; end


class LinkControllerTest < Test::Unit::TestCase
  fixtures :users
  def setup
    @controller = LinkController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_create 
      @request.session[:user]=users(:bob)
      post  :create, :link=>{:description=>'foo', :url=>'bar', :title =>'baz'}
      assert_response :success
      link= Link.find_by_description('foo')
      assert_not_nil link
      assert_equal 'bar', link.url
      assert_template '_links'


  end
end
