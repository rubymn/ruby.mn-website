require File.dirname(__FILE__) + '/../test_helper'
require 'projects_controller'

# Re-raise errors caught by the controller.
class ProjectController; def rescue_action(e) raise e end; end

class ProjectControllerTest < Test::Unit::TestCase
  fixtures :users, :for_hires
  
  def setup
    @controller = ProjectsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @u = users(:bob)
    @p1 = projects(:first)
    @p2 = projects(:second)
    @request.session[:uid]=@u.id
  end
  
  def test_login_not_required
    @request.session[:uid] = nil
    get :index
    assert_response :success
    assert_template 'index'
  end
  
  def test_get_with_id
    get :edit, :id => @p1.id
    assert_response :success
    assert assigns(:project)
    assert_equal @p1, assigns(:project)
    assert_template 'edit'
  end
  
  def test_index
    get :index
    assert_response :success
    assert assigns(:projects)
    assert_template 'index'
  end
  
  def test_create_post
    @request.session[:uid]=@u.id

    post :create, {:project => {:title => 'title', 
                                :url => 'http://example.com', 
                                :source_url => 'http://example.com',
                                :description => "desc"}}
    assert_response :redirect
    assert_redirected_to :action => 'index'
    p = Project.find_by_title 'title'
    assert_not_nil p
    assert_equal @u, p.user
  end
  
  def test_create_get_noid
    get :create
    assert_response :success
    assert_template 'new'
  end
  
  def test_create_post_with_id
    post :create, {:project => {:title => 'title', 
                                :url => 'http://example.com', 
                                :source_url => 'http://example.com',
                                :description => "desc",
                                :id => @p1.id}}
    assert_response :redirect
    assert_redirected_to :action => 'index'
    assert @p1.reload.description = 'desc'
  end
  
  def test_evil_edit
    get :edit, :id => @p2.id
    assert_response :redirect
    assert_redirected_to :controller => 'welcome', :action => 'index'
    assert_nil session[:uid]
  end
  
  def test_destroy
    get :destroy, :id => @p1.id
    assert_response :redirect
    assert_redirected_to :action=>'index'
    begin
      Project.find(1)
      fail "shouldn't be able to find deleted item"
    rescue
    end
  end
  
  def test_evil_destroy
    p = projects(:second)
    get :destroy, :id => p.id
    assert_response :redirect
    assert_redirected_to :controller=>'welcome', :action=>'index'
    assert_nil session[:uid]
    assert Project.find(p.id)
  end

  def test_bad_create_shows_errors
    post :create
    assert_response :success
    assert_template "new"
    assert_select "#errorExplanation" do
      assert_select "ul>li", 3
    end
    assert_not_nil assigns(:project)
    assert !assigns(:project).valid?
  end
  def test_bad_edit_shows_errors
    assert_equal projects(:first).user, users(:bob)
    put :update, :id=>projects(:first).id, :project=>{:title=>''}
    assert_response :success
    assert_template "edit"
    assert_select "#errorExplanation"
    assert_not_nil assigns(:project)
    assert !assigns(:project).valid?
  end
end
