require File.dirname(__FILE__) + '/../test_helper'

class EventTest < Test::Unit::TestCase
  fixtures :events, :users

  # Replace this with your real tests.
  def test_create
    assert_not_nil users(:bob)
    evt = Event.new(:scheduled_time=>Time.now)
    evt.user=users(:bob)
    evt.save
    loaded=Event.find(evt.id)
    assert_not_nil loaded
    assert_equal loaded.user, users(:bob)
  end
end
