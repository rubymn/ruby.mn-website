require File.dirname(__FILE__) + '/../test_helper'

class UserTest < Test::Unit::TestCase
  fixtures :users

  # Replace this with your real tests.
  def test_relation
    u = users(:bob)
    assert_not_nil u
    evt = Event.new(:body=>"foo", :headline=>"bar", :scheduled_time=>Time.now)
    evt.user=u
    assert evt.save
    assert u.save
    assert_equal u.events.size, 2
    assert_equal evt.headline, "bar"
    assert_equal evt.body, "foo"
  end

  def test_extension

  end
end
