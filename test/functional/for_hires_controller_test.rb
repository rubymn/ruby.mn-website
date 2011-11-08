require 'test_helper'

class ForHiresControllerTest < ActionController::TestCase
  context "when routing for this 'has_one' resource" do
    should route(:get,    "/for_hires").to(:controller => :for_hires, :action => :index)
    should route(:get,    "/for_hire").to(:controller => :for_hires, :action => :show)
    should route(:get,    "/for_hire/edit").to(:controller => :for_hires, :action => :edit)
    should route(:get,    "/for_hire/new").to(:controller => :for_hires, :action => :new)
    should route(:post,   "/for_hire").to(:controller => :for_hires, :action => :create)
    should route(:put,    "/for_hire").to(:controller => :for_hires, :action => :update)
    should route(:delete, "/for_hire").to(:controller => :for_hires, :action => :destroy)
  end

  context "not logged in" do
    setup do
      @request.session[:uid] = nil
    end

    context "on GET to :index" do
      setup { get :index }

      should render_template(:index)
      should respond_with(:success)
    end
  end

  context "logged in" do
    setup do
      @u   = login
      @fh1 = Factory.create(:for_hire, :user => @u)
      @fh2 = Factory.create(:for_hire)
    end

    context "get new" do
      setup do
        u = login
        get :new
      end

      should render_template(:new)
      should assign_to(:for_hire)
      should "assign new record" do
        assert assigns(:for_hire).new_record?
      end
    end

    context "get edit with id" do
      setup { get :edit }

      should respond_with(:success)
      should assign_to(:for_hire)
      should render_template(:edit)
      should_not set_the_flash
    end

    context "index" do
      setup { get :index }

      should respond_with(:success)
      should assign_to(:for_hires)
      should render_template(:index)
    end

    def test_create
      u = login
      post :create, :for_hire => { :title => 'title', :blurb => 'blurb', :email => 'email@email.com' }
      assert_response :redirect
      assert_redirected_to for_hires_path
      assert assigns(:for_hire)
      assert_equal assigns(:for_hire).user, u
    end

    context "create with no id" do
      setup do
        u = login
        get :create
      end

      should respond_with(:success)
      #should render_template(:new)
    end

    context "update" do
      setup do
        put :update, :for_hire => { :title => 'title', :blurb => 'test', :email => 'email@email.com' }
      end

      should redirect_to('for_hires index') { for_hires_path }
      should assign_to(:for_hire)
      should set_the_flash.to("Updated for hire entry.")
      should "set blurb" do
        assert_equal @fh1.reload.blurb, 'test'
      end
    end

    context "a malicious edit with a id" do
      setup do
        get :edit, :id => @fh2.id
      end

      should "bounce if an id is supplied to this has_one resource" do
        assert_response :redirect
        assert_redirected_to root_path
        assert_nil session[:uid]
      end
    end

    context "a malicious update with a id" do
      setup do
        put :update, :id => @fh2.id, :for_hire => { :title => 'title', :blurb => 'zz', :email => 'email@email.com' }
      end

      should "bounce if an id is supplied to this has_one resource" do
        assert_response :redirect
        assert_redirected_to root_path
        assert_nil session[:uid]
      end
    end

    context "destroy" do
      setup do
        delete :destroy
      end

      should redirect_to('for_hires index') { for_hires_path }

      should "not find for_hire" do
        begin
          ForHire.find(@fh1.id)
          fail "shouldn't be able to find deleted item"
        rescue
        end
      end
    end

    context "a malicious delete with a id" do
      setup do
        @fh = Factory :for_hire
        get :destroy, :id => @fh.id
      end

      should "bounce if an id is supplied to this has_one resource" do
        assert_response :redirect
        assert_redirected_to :controller => 'welcome', :action => 'index'
        assert_nil session[:uid]
        assert ForHire.find(@fh.id)
      end
    end
  end
end
