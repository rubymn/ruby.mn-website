require File.dirname(__FILE__) + '/../test_helper'

class BookTest < Test::Unit::TestCase
  fixtures :books, :users, :users_books

  def test_book_validates
    b = Book.new
    assert !b.save
    assert "can't be blank", b.errors.on(:title)
    assert "can't be blank", b.errors.on(:author)
    assert "can't be blank", b.errors.on(:isbn)
    assert "can't be blank", b.errors.on(:description)
  end


  def test_habtm_owners

  end

  def test_fixtures
    assert_not_nil books(:first)
    assert_not_nil books(:second)
    assert_not_nil books(:first).users
    assert_not_nil books(:second).users
    assert_equal 2, books(:first).users.size
    assert_equal 1, users(:existingbob).books.size
  end
end
