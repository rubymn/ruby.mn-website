require 'test_helper'

class EventTest < ActiveSupport::TestCase
  should validate_presence_of :headline
  should validate_presence_of :scheduled_time
  should validate_presence_of :body
  should validate_presence_of :user_id

  context "formatted scheduled time" do
    @event = Factory.build :event
    should "display formatted scheduled time" do
      assert_equal @event.formatted_scheduled_time, @event.scheduled_time.strftime('%m/%d/%g %I:%M%p')
    end
  end

  context "formatted scheduled time =" do
    setup do
      @event = Factory.build :event
    end

    test "mm/dd/yy HH:MMAP" do
      @expected = "12/24/11 12:00PM"
      @event.formatted_scheduled_time = @expected
      should "display formatted scheduled time" do
        assert_equal @event.formatted_scheduled_time, Chronic.parse(@expected)
      end
    end
  end
end
