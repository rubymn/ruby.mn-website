class BookController < ApplicationController
  before_filter :login_required

  def delete
    @book = Book.find(params[:id])
    if @book.users.include?(session[:user])
      @book.users.delete(session[:user])
      if @book.users.size == 0
        @book.destroy
        @book=nil
      end
    end
  end

  def addme
    @book = Book.find(params[:id])
    if not @book.users.include?(session[:user])
      @book.users << session[:user]
      @success = true
    end
  end

  def index
    @books=Book.find(:all, :order=>'title')
  end

  def new
    @book=Book.new(params['book'])
    @success = @book.save
    if @success
    @book.users << session[:user]
    @success = @book.save
    end
  end


  def add
  end

  def hide_form
  end

end
