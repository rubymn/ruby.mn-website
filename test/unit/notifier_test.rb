require File.dirname(__FILE__) + '/../test_helper'

class OpeningNotificationTest < Test::Unit::TestCase
  fixtures :openings,:events, :users
  FIXTURES_PATH = File.dirname(__FILE__) + '/../fixtures'
  CHARSET = "utf-8"

  include ActionMailer::Quoting

  def setup
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []

    @expected = TMail::Mail.new
    @expected.set_content_type "text", "plain", { "charset" => CHARSET }
    @expected.mime_version = '1.0'
  end

  def test_opening_notify
    o = openings(:first)
    res = Notifier.create_notify_opening(o)
    assert_equal 'test@example.com', *res.to
    assert_equal "New Opening Posted: #{o.headline}", res.subject
    assert_equal 'notifications@ruby.mn', *res.from
  end

  def test_event_notify
    e = events(:notapproved)
    res = Notifier.create_notify_event(e)
    assert_equal 'm@loonsoft.com', *res.to
    assert_equal "New Event Posted", res.subject
    assert_equal 'notifications@ruby.mn', *res.from
  end


  private
    def read_fixture(action)
      IO.readlines("#{FIXTURES_PATH}/opening_notification/#{action}")
    end

    def encode(subject)
      quoted_printable(subject, CHARSET)
    end

end
