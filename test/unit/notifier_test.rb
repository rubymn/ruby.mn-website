require 'test_helper'

class OpeningNotificationTest < ActionMailer::TestCase
  def test_opening_notify
    o   = Factory :opening
    res = Notifier.notify_opening(o)
    assert_equal 'test@example.com', *res.to
    assert_equal "New Opening Posted: #{o.headline}", res.subject
    assert_equal *res.from, NOTIFICATION_ADDRESS
  end

  def test_event_notify
    e   = Factory :event
    res = Notifier.notify_event(e)
    assert_equal TCRBB_LIST_ADDRESS, *res.to
    assert_equal "New Event Posted", res.subject
    assert_equal *res.from, NOTIFICATION_ADDRESS
  end
end
