# == Schema Information
#
# Table name: events
#
#  id             :integer          not null, primary key
#  created_at     :datetime
#  scheduled_time :datetime
#  headline       :string(200)      default(""), not null
#  body           :text             not null
#  user_id        :integer          default(0), not null
#  approved       :boolean          default(FALSE)
#

require 'test_helper'

class EventTest < ActiveSupport::TestCase
  should validate_presence_of :headline
  should validate_presence_of :scheduled_time
  should validate_presence_of :body
  should validate_presence_of :user_id

  context "formatted scheduled time" do
    setup do
      @event = Factory.build :event
    end

    should "display formatted scheduled time" do
      assert_equal @event.formatted_scheduled_time, @event.scheduled_time.strftime('%m/%d/%Y %I:%M%p')
    end
  end

  # context "formatted scheduled time equals" do
  #   setup do
  #     @event = Factory.build :event
  #     @expected = "12/24/11 12:00PM"
  #     @event.formatted_scheduled_time = @expected
  #   end

  #   should "display formatted scheduled time" do
  #     assert_equal @event.formatted_scheduled_time, Chronic.parse(@expected)
  #   end
  # end
end
