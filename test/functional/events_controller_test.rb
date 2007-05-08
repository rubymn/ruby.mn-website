require File.dirname(__FILE__) + '/../test_helper'
require 'events_controller'

# Re-raise errors caught by the controller.
class EventsController; def rescue_action(e) raise e end; end

class EventsControllerTest < Test::Unit::TestCase
  fixtures :users,:events
  def setup
    @controller = EventsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_routes
    assert_restful_routes(:events)
    assert_recognizes({:controller=>"events", :action=>'approve', :id=>'1'}, {:path=> "/events/1;approve", :method=>:put})
  end



  def test_create
    login_as(:bob)
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

  def test_badcreate
    login_as(:bob)
    time = Time.now.strftime("%R %F")
    post :create, {:event=>{}}
    assert assigns(:event)
    assert_equal "can't be blank", assigns(:event).errors[:headline]
  end

  def test_index
    login_as(:bob)
    get :index
    assert_template "index"
    assert assigns(:events)
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
    assert !Event.exists?(1)
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
      
      login_as(:bob)
      get :destroy, :id=>events(:another).id
      assert_not_nil events(:another)
      assert_response :redirect
      assert_redirected_to :controller=>"user", :action=>"login"
      assert_nil @request.session[:uid]
      
  end

  
  def test_edit
    login_as(:bob)
    get :edit, :id=>events(:first).id
    assert_response :success
    assert assigns(:event)
    assert_template 'edit'
    assert assigns(:event)
    assert_equal events(:first), assigns(:event)
  end

  def test_evil_edit
    login_as(:existingbob)
    get :edit, :id=>events(:first).id
    assert_response :redirect
    assert_redirected_to :controller=>'user', :action=>'login'
    assert_equal "Access Denied", flash[:error]
    assert_nil session[:uid]
  end
  

  def test_edit_permission
      login_as(:bob)
      get :edit, :id=>2
      assert_response :redirect
      assert_redirected_to :controller=>'user', :action=>'login'
      assert_nil session[:uid]

  end

  def test_update
    login_as(:bob)
    put :update, :id=>events(:first).id, :event=>{:headline=>'fubar'}
    assert assigns(:event)
    assert_response :redirect
    assert_redirected_to event_path(assigns(:event))
    assert_equal "fubar", assigns(:event).headline
  end


  def test_show
    login_as(:admin)
    get :show, :id=>1
    assert_response :success
    assert_template 'show'
    assert assigns(:event)

  end
  def test_new
    login_as(:bob)
    get :new
    assert_response :success
    assert_template 'new'
    assert assigns(:event)
    assert assigns(:event).new_record?
  end
end
