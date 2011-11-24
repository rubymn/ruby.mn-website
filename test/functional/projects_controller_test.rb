require 'test_helper'
class ProjectsControllerTest < ActionController::TestCase
  def setup
    @p1 = Factory.create :project
    @p2 = Factory.create :project
    @request.session[:uid]=@p1.user.id
  end
  
  def test_login_not_required
    get :index
    assert_response :success
    assert_template :index
  end
  
  def test_get_with_id
    get :edit, :id => @p1.id
    assert_response :success
    assert assigns(:project)
    assert_equal @p1, assigns(:project)
    assert_template :edit
  end
  
  def test_index
    get :index
    assert_response :success
    assert assigns(:projects)
    assert_template :index
  end
  
  def test_create_post

    post :create, {:project => {:title => 'title', 
                                :url => 'http://example.com', 
                                :source_url => 'http://example.com',
                                :description => "desc"}}
    assert_response :redirect
    assert_redirected_to :action => :index, :controller => :projects
    p = Project.find_by_title 'title'
    assert_not_nil p
    assert_equal @p1.user, p.user
  end
  
  def test_create_get_noid
    get :create
    assert_response :success
    assert_template :new
  end
  
  def test_create_post_with_id
    post :create, {:project => {:title => 'title', 
                                :url => 'http://example.com', 
                                :source_url => 'http://example.com',
                                :description => "desc",
                                :id => @p1.id}}
    assert_response :redirect
    assert_redirected_to :action => :index, :controller => :projects
    assert @p1.reload.description = 'desc'
  end
  
  def test_evil_edit
    get :edit, :id => @p2.id
    assert_response :redirect
    assert_redirected_to :controller => :welcome, :action => :index
    assert_nil session[:uid]
  end
  
  def test_destroy
    get :destroy, :id => @p1.id
    assert_response :redirect
    assert_redirected_to :action => :index, :controller => :projects
    begin
      Project.find(1)
      fail "shouldn't be able to find deleted item"
    rescue
    end
  end
  
  def test_evil_destroy
    p = @p2
    get :destroy, :id => p.id
    assert_response :redirect
    assert_redirected_to :controller => :welcome, :action => :index
    assert_nil session[:uid]
    assert Project.find(p.id)
  end

  def test_bad_create_shows_errors
    post :create
    assert_response :success
    assert_template "new"
    assert_not_nil assigns(:project)
    assert !assigns(:project).valid?
  end
  def test_bad_edit_shows_errors
    assert_not_nil  @p1.user
    put :update, :id=>@p1.id, :project=>{:title=>''}
    assert_response :success
    assert_template :edit
    assert_not_nil assigns(:project)
    assert !assigns(:project).valid?
  end
end
