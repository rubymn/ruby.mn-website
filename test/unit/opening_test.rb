require File.dirname(__FILE__) + '/../test_helper'

class OpeningTest < Test::Unit::TestCase
  fixtures :openings, :users

  # Replace this with your real tests.
  def test_create
    Opening.destroy_all
    op = Opening.new
    op.user = users(:bob)
    assert op.save
    users(:bob).openings << op

    u = User.find(users(:bob).id)
    assert_equal 1, u.openings.size
  end
end
