require 'test_helper'

class ForHiresControllerTest < ActionController::TestCase
  context "when routing for this 'has_one' resource" do
    should_route :get,    "/for_hires",        :controller => :for_hires, :action => :index
    should_route :get,    "/for_hire",      :controller => :for_hires, :action => :show
    should_route :get,    "/for_hire/edit", :controller => :for_hires, :action => :edit
    should_route :get,    "/for_hire/new",    :controller => :for_hires, :action => :new
    should_route :post,   "/for_hire",        :controller => :for_hires, :action => :create
    should_route :put,    "/for_hire",      :controller => :for_hires, :action => :update
    should_route :delete, "/for_hire",      :controller => :for_hires, :action => :destroy
  end
  
  context "not logged in" do
    setup do
      @request.session[:uid]=nil
    end
    context "on GET to :index" do
      setup { get :index }

      should "not require login on :index" do
        assert_response :success
        assert_template 'index'
      end
    end
  end
  

  context "logged in" do
    setup do
      @u = login
      @fh1 = Factory.create(:for_hire)
      @fh2 = Factory.create(:for_hire)
      @u = @fh1.user
    end
    
    context "get new" do
      setup { get :new }
      should_render_template 'new'
      should_assign_to(:for_hire) do
        assert assigns(:for_hire).new_record?
      end
    end

    def test_get_with_id
      get :edit, :id=>@fh1.id
      assert_response :success
      assert assigns(:for_hire)
      assert_equal @fh1, assigns(:for_hire)
      assert_template 'edit'

    end

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
      assert_redirected_to for_hires_path
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
        :blurb=>'test', :email=>'email@email.com'}}
      assert_response :redirect
      assert_redirected_to for_hires_path
      assert @fh1.reload.blurb='test'
    end

    context "a malicious edit with a id" do
      setup do
        get :edit, :id=>@fh2.id
      end

      should "bounce if an id is supplied to this has_one resource" do
        assert_response :redirect
        assert_redirected_to :controller=>'welcome', :action=>'index'
        assert_nil session[:uid]
      end
    end

    context "a malicious update with a id" do
      setup do
        put :update, :id=>@fh2.id, :for_hire=>{:title=>'title', 
          :blurb=>'zz', :email=>'email@email.com'}
      end

      should "bounce if an id is supplied to this has_one resource" do
        assert_response :redirect
        assert_redirected_to :controller=>'welcome', :action=>'index'
        assert_nil session[:uid]
      end
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

    context "a malicious delete with a id" do
      setup do
        @fh = Factory.create(:for_hire)
        get :destroy, :id=>@fh.id
      end

      should "bounce if an id is supplied to this has_one resource" do
        assert_response :redirect
        assert_redirected_to :controller=>'welcome', :action=>'index'
        assert_nil session[:uid]
        assert ForHire.find(@fh.id)
      end
    end
  
  end
  
end
