require 'test_helper'

class ForHiresControllerTest < ActionController::TestCase
  should_route :get, "/for_hires/new", :action=>'new'
  context "logged in" do
    setup {@u=login}
    context "get new" do
      setup {get :new}
      should_render_template 'for_hire_form'
      should_assign_to(:for_hire) do
        assert assigns(:for_hire).new_record?
      end
    end
  end
  def setup
    @fh1 = Factory.create(:for_hire)
    @fh2 = Factory.create(:for_hire)
    @u = @fh1.user
    login_as(@u)
  end
  def test_login_not_required
    @request.session[:uid]=nil
    get :index
    assert_response :success
    assert_template 'index'

  end

  def test_get_with_id
    get :edit, :id=>@fh1.id
    assert_response :success
    assert assigns(:for_hire)
    assert_equal @fh1, assigns(:for_hire)
    assert_template 'for_hire_form'

  end

  # Replace this with your real tests.
  def test_index
    get :index
    assert_response :success
    assert assigns(:for_hires)
    assert_template 'index'
  end

  def test_create
    u =login
    post :create, {:for_hire=>{:title=>'title', 
      :blurb=>'blurb', :email=>'email@email.com'}}
    assert_response :redirect
    assert_redirected_to user_for_hire_path(u)
    assert assigns(:for_hire)
    assert_equal assigns(:for_hire).user, u

  end

  def test_create_get_noid
    get :create
    assert_response :success
    assert_template 'for_hire_form'
  end

  def test_update
    put :update, {:for_hire=>{:title=>'title', 
      :blurb=>'test', :email=>'email@email.com'}, :user_id=>@u.id}
    assert_response :redirect
    assert_redirected_to user_for_hire_path(@u)
    assert @fh1.reload.blurb='test'
  end

  def test_evil_edit
    get :edit, :id=>@fh2.id
    assert_response :success
    assert_equal assigns(:for_hire), @u.for_hire
  end

  def test_evil_update
    login_as Factory.create(:user)
    post :create, :for_hire=>{:title=>'title', 
      :blurb=>'zz', :email=>'email@email.com', :user_id=>@u.id}
    assert_response :redirect
    assert_equal assigns(:for_hire).blurb, 'zz'
  end


  def test_destroy
    get :destroy, :id=>@fh1.id
    assert_response :redirect
    assert_redirected_to :action=>'index'
    begin
      ForHire.find(1)
      fail "shouldn't be able to find deleted item"
    rescue
    end
  end

  def test_evil_destroy
    fh = Factory.create(:for_hire)
    get :destroy, :id=>fh.id
    assert_response :redirect
    assert_redirected_to :controller=>'welcome', :action=>'index'
    assert_nil session[:uid]
    assert ForHire.find(fh.id)
  end
end
