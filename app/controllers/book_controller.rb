class BookController < ApplicationController
  before_filter :login_required

  def delete
    @book = Book.find(params[:id])
    if @book.user.id == session[:user].id
      @book.destroy
    end
  end

  def index
    @books=Book.find(:all, :order=>'title')
  end

  def new
    @book=Book.new(params['book'])
    @book.user_id=session[:user].id
    @success=@book.save
  end


  def add
  end

  def hide_form
  end

end
