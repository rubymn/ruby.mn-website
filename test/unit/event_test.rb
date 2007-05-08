require File.dirname(__FILE__) + '/../test_helper'

class EventTest < Test::Unit::TestCase
  fixtures :events, :users

  def test_create
    assert_not_nil users(:bob)
    evt = Event.new(:scheduled_time=>Time.now, :user_id=>users(:bob).id, :body=>'voo', :headline=>'bar')
    evt.user=users(:bob)
    evt.save
    loaded=Event.find(evt.id)
    assert_not_nil loaded
    assert_equal loaded.user, users(:bob)
    assert !evt.approved
  end

  def test_fixtures
    Event.find(:all).each do |e|
      assert e.valid?, "#{e.id} is invalid"
    end
  end
end
