require File.dirname(__FILE__) + '/../test_helper'
require 'event_controller'

# Re-raise errors caught by the controller.
class EventController; def rescue_action(e) raise e end; end

class EventControllerTest < Test::Unit::TestCase
  fixtures :users,:events
  def setup
    @controller = EventController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end



  def test_create_got
    @request.session[:user]=users(:bob)
    get :create
    assert_response :success
    assert_template 'event_form'
  end

  def test_create_post
    @request.session[:user]=users(:bob)
    time = Time.now.strftime("%R %F")
    post :create, {:event=>{:headline=>"foo", :body=>"bar", :scheduled_time=>time}}
    saved = users(:bob).events[1]
    assert_not_nil saved
    assert_equal "bar", saved.body
    assert_equal "foo", saved.headline
    assert_equal time, saved.scheduled_time.strftime("%R %F")
    assert_equal users(:bob), saved.user
    assert_not_nil saved.created_at
    assert_equal users(:bob), saved.user
  end

  def test_index
    @request.session[:user]=users(:bob)
    get :index
    assert_template "index"

  end

  def test_destroy
    @request.session[:user]=users(:bob)
    get :destroy, :id=>events(:first).id
    begin
    Event.find(1)
    fail "shouldn't work."
    rescue
    end
    assert_redirected_to :action=>'index'
  end
  
  def test_destroy_permission
      
      @request.session[:user]=users(:bob)
      get :destroy, :id=>events(:another).id
      assert_not_nil events(:another)
      assert_response :redirect
      assert_redirected_to :controller=>"welcome", :action=>"index"
      assert_nil @request.session[:user]
      
  end

  

  def test_edit_directs_to_form
      @request.session[:user]=users(:bob)
    get :edit, :id=>1
    assert_response :success
    assert_template 'event_form'
    assert assigns(:id)

  end
  
  def test_edit_posting
      @request.session[:user]=users(:bob)
    time = Time.now.strftime("%R %F")
    post :create, {:event=>{:headline=>"foo", :body=>"bar", :scheduled_time=>time, :id=>events(:another).id}}
    assert_response :redirect
    assert_redirected_to :action=>'index'
    saved = Event.find(events(:another).id)
    assert_equal "bar", saved.body
    assert_equal "foo", saved.headline


  end

  def test_edit_permission
      @request.session[:user]=users(:bob)
      get :edit, :id=>2
      assert_response :redirect
      assert_redirected_to :controller=>'welcome'
      assert_nil session[:user]

  end
end
