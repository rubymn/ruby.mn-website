require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  should_route :get, '/users/mml/edit', :action => 'edit', :id=>'mml'
  should_route :put, '/users/mml', :action => 'update', :id=>'mml'
  should_route :get, '/users', :action => 'index'
  should_route :post, '/users', :action => 'create'
  should_route :get, '/users/new', :action => 'new'


  context "a logged in user" do
    setup do
      @u = Factory.create :user
      @request.session[:uid]=@u.id
    end 
    context "get edit" do
      setup { get :edit, :id => @u.login }
      should_render_template 'user_form'
      should_assign_to :user do
        assert_equal assigns(:user), @u
      end
      should "have the form" do
        assert_select "form[action=?][enctype=multipart/form-data]", user_path(@u) do
          assert_select "input[type=file][id=user_beard]"
          assert_select "input[type=submit]"
        end
      end
    end
    context "put update" do
      setup do
        @ffile = fixture_file_upload("files/beard.jpg")
        put :update, :id => @u.login, :user=>{:beard=>@ffile}
      end
      should_respond_with :redirect
      should_redirect_to 'bearddex' do 
        bearddex_path
      end
      should_set_the_flash_to "Thanks, bearddex updated."
    end
  end

  def test_new
    get :new
    assert_response :success
    assert_template 'new'
    assert assigns(:user)
    assert assigns(:user).new_record?
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
    post :create, {"user"=>{"password_confirmation"=>"standard", "lastname"=>"Looney", 
      "firstname"=>"MCClain", "login"=>"mogwai", "password"=>"standard", "email"=>"m@loonsoft.com"}}
    assert_response :redirect
    assert_redirected_to  :controller=>'welcome', :action=>'index'
    assert_nil flash[:warning]
    assert_equal "Please check your registered email account to verify your account.", flash[:notice]
    assert_nil flash[:warning]
    assert assigns(:user)
    assert_response :redirect
  end

  def test_password_conf
    post :create, "user"=>{"password_confirmation"=>"fu", "lastname"=>"looney", "firstname"=>"mcclain", "login"=>"mml", "password"=>"standard", "email"=>"m@loonsoft.com"} , :recatcha_challenge_field=>'foo', :recaptcha_response_field=>'foo'

    assert_response :success
    assert_template 'users/new'
    assert assigns(:user)
    assert_equal ["Password doesn't match confirmation"] ,assigns(:user).errors.each_full{}
  end
  def test_empty_pass
    post :create, "user"=>{ "lastname"=>"looney", "firstname"=>"mcclain", "login"=>"mml",  "email"=>"m@loonsoft.com"} 

    assert_response :success
    assert_template 'new'
    assert assigns(:user)
    assert_equal ["Password can't be blank"] ,assigns(:user).errors.each_full{}
  end


  def test_create2
    post :create, "user"=>{"password_confirmation"=>"standard", "lastname"=>"looney", "firstname"=>"mcclain", "login"=>"tutu", "password"=>"standard", "email"=>"m@loonsoft.com"} 
    assert_response :redirect
    assert_redirected_to :controller=>'welcome', :action=>'index'
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
    u = Factory.create(:user, :verified=>false, :security_token=>'meh')
    assert !User.find(u.id).verified?
    get :validate, "key"=>'meh'
    assert u.reload.verified?
    assert_response :redirect
    assert_redirected_to :controller=>'welcome', :action=>'index'
  end

end
