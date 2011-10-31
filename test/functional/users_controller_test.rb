require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  should route(:get, '/users').to(:action => 'index')
  should route(:post, '/users').to(:action => 'create')
  should route(:get, '/users/new').to(:action => 'new')
  should route(:post, "/users/new/set_password").to(:action => :set_password)
  should route(:get, "/users/new/validate").to(:action => :validate)
  should route(:get, "/users/new/forgot_password").to(:action => :forgot_password)
  should route(:post, "/users/new/reset").to(:action => :reset)
  should route(:get, "/users/new/change_password").to(:action => :change_password)

  context "get new" do
    setup { get :new }

    should respond_with(:success)
    should render_template(:new)
    should assign_to(:user)
    should "assign new user record" do
      assert assigns(:user).new_record?
    end
  end

  context "get edit" do
    setup do
      @user = Factory :user
      get :edit, :id => @user.to_param
    end

    should redirect_to('login page') { new_session_path }
    should set_the_flash.to("Access Denied")
    should_not assign_to(:user)
  end

  context "put update" do
    setup do
      @user = Factory :user
      put :update, :id => @user.to_param, :user => { :email => 'foo@example.com' }
    end

    should redirect_to('login page') { new_session_path }
    should set_the_flash.to("Access Denied")
    should_not assign_to(:user)
  end

  context "logged in" do
    setup { @user = login }
    context "get edit" do
      setup do
        get :edit, :id => @user.to_param
      end

      should respond_with(:success)
      should assign_to(:user)
      should render_template(:edit)
    end

    context "put update" do
      setup do
        put :update, :id => @user.to_param, :user => { :firstname => "John", :lastname => "Jones", :email => 'johnjones@example.com' }
      end

      should redirect_to('edit page') { edit_user_path(assigns(:user)) }
      should set_the_flash.to("User account updated successfully.") 
      should assign_to(:user)
    end
  end

  def test_index
    get :index
    assert_bounced
  end

  def test_index_logged_in
    login
    get :index
    assert_response :success
    assert assigns(:users)
  end

  def test_create
    post :create, :user => { :password_confirmation => "standard", :lastname => "Looney", :firstname => "MCClain", :login => "mogwai", :password => "standard", :email => "m@loonsoft.com" }
    assert_response :redirect
    assert_redirected_to root_path
    assert_equal "Please check your registered email account to verify your account.", flash[:notice]
    assert assigns(:user)
    assert_response :redirect
  end

  def test_password_conf
    post :create, :user => { :password_confirmation => "fu", :lastname => "looney", :firstname => "mcclain", :login => "mml", :password => "standard", :email => "m@loonsoft.com" } , :recatcha_challenge_field => 'foo', :recaptcha_response_field => 'foo'

    assert_response :success
    assert_template 'users/new'
    assert assigns(:user)
    assert_equal ["Password doesn't match confirmation"] ,assigns(:user).errors.each_full{}
  end

  def test_empty_pass
    post :create, :user => { :lastname => "looney", :firstname => "mcclain", :login => "mml",  :email => "m@loonsoft.com" }

    assert_response :success
    assert_template 'new'
    assert assigns(:user)
    assert_equal ["Password can't be blank"] ,assigns(:user).errors.each_full{}
  end


  def test_create2
    post :create, :user => { :password_confirmation => "standard", :lastname => "looney", :firstname => "mcclain", :login => "tutu", :password => "standard", :email => "m@loonsoft.com" } 
    assert_redirected_to root_path
    assert flash[:notice]
    u = User.find_by_login('tutu')
    assert_not_nil u
    u.reload
    assert !u.verified?
    u.verified = true
    u.save!
    u.reload
    u = User.find_by_login('tutu')
    assert_not_nil u
    assert u.verified?
    assert_not_nil u.salted_password
    assert_not_nil u.salt
  end

  def test_validate
    @request.session[:uid] = nil
    u = Factory.create(:user, :verified => false, :security_token => 'meh')
    assert !User.find(u.id).verified?
    get :validate, :key => 'meh'
    assert u.reload.verified?
    assert_response :redirect
    assert_redirected_to root_path
  end

end
