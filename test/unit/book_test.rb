require File.dirname(__FILE__) + '/../test_helper'

class BookTest < Test::Unit::TestCase
  fixtures :books, :users

  def test_fixtures
    assert_not_nil books(:first)
    assert_not_nil books(:second)
    assert_not_nil books(:first).user
    assert_not_nil books(:second).user
    assert_equal books(:first).user, books(:second).user
  end
end
