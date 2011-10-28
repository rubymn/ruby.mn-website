require File.dirname(__FILE__) + '/../test_helper'

class EventsControllerTest < ActionController::TestCase
  context "Logged in as a user with events" do
    setup do
      @user = Factory(:user)
      @ev1=Factory.create(:event, :user => @user)
      @ev2=Factory.create(:event, :user => @user)
      @ev_nappr=Factory.create(:event, :user => @user, :approved=> false)
      login_as @user
    end
    
    context "on GET to :index" do
      setup { get :index }
      
      should respond_with :success
      should assign_to :events
      should assign_to :user
    end
  end
  
  
  def setup
    @ev1=Factory.create(:event)
    @ev2=Factory.create(:event)
    @ev_nappr=Factory.create(:event, :approved=> false)
    login_as(@ev1.user)
    @owner = @ev1.user
    @x = Factory.create(:user)
    @admin = Factory.create(:user, :role => 'admin')
  end

  


  def test_create
    time = Time.now.strftime("%R %F")
    post :create, {:event=>{:headline=>"foo", :body=>"bar", :scheduled_time=>time}}
    assert assigns(:event)
    assert_equal @owner, assigns(:event).user
    saved = assigns(:event)
    assert_not_nil saved
    assert_equal "bar", saved.body
    assert_equal "foo", saved.headline
    assert_equal time, saved.scheduled_time.strftime("%R %F")
    assert_equal @owner, saved.user
    assert_not_nil saved.created_at
    assert_equal @owner, saved.user
  end

  def test_badcreate
    time = Time.now.strftime("%R %F")
    post :create, {:user_id=>'bob', :event=>{}}
    assert assigns(:event)
    assert_equal "can't be blank", assigns(:event).errors[:headline]
  end

  def test_index_admin
    login_as(@admin)
    get :user_index, :user_id=>@x.id
    assert_template "index"
    assert assigns(:events)
  end
  
  def test_index_admin_no_user_id_param
    login_as(@admin)
    get :user_index
    assert_template "index"
    assert assigns(:events)
  end
  
  def test_uindex_notadmin
    login_as(@x)
    get :user_index
    assert_template "index"
    assert assigns(:events)
  end



  def test_approve_badlogin
    login_as(@x)
    assert_raises ActiveRecord::RecordNotFound do
      put :approve, :id=>@ev_nappr.id, :user_id=>@x.login
    end
    assert !@ev_nappr.approved?
  end


  def test_destroy
    get :destroy, :id=>@ev1.id, :user_id=>'bob'
    assert !Event.exists?(1)
    assert_redirected_to admindex_path
  end

  def test_destroy_as_admin
    login_as(@admin)
    delete :destroy, :id=>@ev1.id
    assert_response :redirect
    assert_redirected_to :controller=>'admin', :action=>'index'
    assert !Event.exists?(@ev1.id)
  end
  def test_destroy_as_notadmin
    login_as(@x)
    assert_raises ActiveRecord::RecordNotFound do
      delete :destroy, :id=>@ev1.id, :user_id=>@owner.login
    end
    assert Event.exists?(@ev1.id)
  end
  
  def test_destroy_permission
    login_as(@x)
    assert_raises ActiveRecord::RecordNotFound do
      get :destroy, :id=>@ev2.id
    end
  end

  
  def test_edit
    get :edit, :id=>@ev1.id, :user_id=>'bob'
    assert_response :success
    assert assigns(:event)
    assert_template 'edit'
    assert assigns(:event)
    assert_equal @ev1, assigns(:event)
  end

  def test_evil_edit
    login_as(@x)
    assert_raises ActiveRecord::RecordNotFound do 
      get :edit, :id=>@ev1.id, :user_id=>@owner.id
    end
  end
  

  def test_edit_permission
    login_as(@x)
    assert_raises ActiveRecord::RecordNotFound do
      get :edit, :id=>@ev2.id
    end
  end


  def test_update
    login_as(@owner)
    put :update, :id=>@ev1.id, :event=>{:headline=>'fubar'}
    assert assigns(:event)
    assert_response :redirect
    assert_redirected_to event_path(assigns(:event))
    assert_equal "fubar", assigns(:event).headline
  end


  def test_show
    login_as(@admin)
    get :show, :id=>@ev1.id
    assert_response :success
    assert_template 'show'
    assert assigns(:event)

  end
  def test_new
    get :new, :user_id=>@owner.id
    assert_response :success
    assert_template 'new'
    assert assigns(:event)
    assert assigns(:event).new_record?
  end
end
