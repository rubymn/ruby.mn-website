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
    @request.session[:uid]=users(:bob).id
    get :create
    assert_response :success
    assert_template 'event_form'
  end

  def test_create_post
    @request.session[:uid]=users(:bob).id
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
    @request.session[:uid]=users(:bob).id
    get :index
    assert_template "index"

  end



  def test_approve_badlogin
    login_as(:bob)
    assert !events(:notapproved).approved?
    get :approve, :id=>events(:notapproved).id
    assert_response :redirect
    assert_redirected_to :controller=>'user', :action=>'login'
    assert_equal flash[:error], 'Access Denied'
    assert !events(:notapproved).approved?
  end

  def test_admin_approve
    login_as(:admin)
    assert !events(:notapproved).approved?
    get :approve, :id=>events(:notapproved).id
    assert_response :redirect
    assert_redirected_to :controller=>'admin', :action=>'index'
    events(:notapproved).reload
    assert events(:notapproved).approved?
    assert_equal flash[:info], 'Event Approved'
  end

  def test_destroy
    @request.session[:uid]=users(:bob).id
    get :destroy, :id=>events(:first).id
    begin
    Event.find(1)
    fail "shouldn't work."
    rescue
    end
    assert_redirected_to :action=>'index'
  end

  def test_destroy_as_admin
    login_as(:admin)
    get :admdestroy, :id=>events(:first).id
    assert_response :redirect
    assert_redirected_to :controller=>'admin', :action=>'index'
    assert !Event.exists?(events(:first).id)
  end
  def test_destroy_as_notadmin
    login_as(:notadmin)
    get :admdestroy, :id=>events(:first).id
    assert_response :redirect
    assert_redirected_to :controller=>'user', :action=>'login'
    assert_nil session[:uid]
    assert Event.exists?(events(:first).id)
  end
  
  def test_destroy_permission
      
      @request.session[:uid]=users(:bob).id
      get :destroy, :id=>events(:another).id
      assert_not_nil events(:another)
      assert_response :redirect
      assert_redirected_to :controller=>"welcome", :action=>"index"
      assert_nil @request.session[:uid]
      
  end

  

  def test_edit_directs_to_form
    @request.session[:uid]=users(:bob).id
    get :edit, :id=>1
    assert_response :success
    assert_template 'event_form'
    assert assigns(:id)

  end
  
  def test_edit_posting
      @request.session[:uid]=users(:bob).id
    time = Time.now.strftime("%R %F")
    post :create, {:event=>{:headline=>"foo", :body=>"bar", :scheduled_time=>time, :id=>events(:another).id}}
    assert_response :redirect
    assert_redirected_to :action=>'index'
    saved = Event.find(events(:another).id)
    assert_equal "bar", saved.body
    assert_equal "foo", saved.headline


  end

  def test_edit_permission
      @request.session[:uid]=users(:bob).id
      get :edit, :id=>2
      assert_response :redirect
      assert_redirected_to :controller=>'welcome'
      assert_nil session[:uid]

  end
end
