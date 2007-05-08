require File.dirname(__FILE__) + '/../test_helper'
require 'book_controller'

# Re-raise errors caught by the controller.
class BookController; def rescue_action(e) raise e end; end

class BookControllerTest < Test::Unit::TestCase
  fixtures :users, :books, :users_books
  def setup
    @controller = BookController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end


  def test_req_login
    get :index
    assert_bounced
  end

  def test_index
    @request.session[:uid]=users(:bob).id
    get :index
    assert_response :success
    assert_template 'index'
    assert assigns(:books)
  end

  def test_new
    @request.session[:uid]=users(:bob).id
    post :new, "book"=>{"title"=>"foo","author"=>"bar", "isbn"=>"abcd", "description"=>"description"}
    assert_response :success
    assert assigns(:book)
    assert assigns(:success) == true
    assert_template 'new'
    b= Book.find_by_title('foo')
    assert_not_nil b
    assert users(:bob).books.include?(assigns(:book))
    assert b.users.include?(users(:bob))
  end

  def test_bad_new
    @request.session[:uid]=users(:bob).id
    post :new, "book"=>{:title=>'', :author=>'', :isbn=>'', :description=>''}
    assert_response :success
    assert assigns(:success)==false
    assert assigns(:book)
    assert_equal "can't be blank", assigns(:book).errors.on(:title)
    assert_equal "can't be blank", assigns(:book).errors.on(:author)
    assert_equal "can't be blank", assigns(:book).errors.on(:isbn)
    assert_equal "can't be blank", assigns(:book).errors.on(:description)
  end

  def test_add
    @request.session[:uid]=users(:bob).id
    post :add
    assert_response :success
    assert_template 'add'
  end

  def test_hide_form
    @request.session[:uid]=users(:bob).id
    post :hide_form
    assert_response :success
    assert_template 'hide_form'
  end

  def test_addme
    b = Book.new(:title=>'fubar', :author=>'abaz', :isbn=>'asdf', :description=>'blah')
    b.save!
    @request.session[:uid]=users(:bob).id
    post :addme, :id=>b.id
    assert_response :success
    assert_template 'addme'
    assert assigns(:book) != nil
    assert assigns(:success)==true
    b.reload
    assert b.users.include?(users(:bob))
    assert users(:bob).books.include?(b)

  end

  def test_delete_book
    @request.session[:uid]=users(:bob).id
    post :delete, "id"=>books(:first).id
    assert_response :success
    assert_template 'delete'
    assert !users(:bob).books.include?(books(:first))
    assert !books(:first).users.include?(users(:bob))
    assert users(:existingbob).books.include?(books(:first))
    assert books(:first).users.include?(users(:existingbob))
    @request.session[:uid]=users(:existingbob).id
    post :delete, "id"=>books(:first).id
    assert !Book.exists?(books(:first).id)
    assert (assigns(:book)== nil)
  end

end
