require 'test_helper'

class OpeningTest < ActiveSupport::TestCase
  should belong_to :user
  should validate_presence_of :body
  should validate_presence_of :headline

  context "an instance" do
    setup do
      @u = Factory.create(:user)
      @o = @u.openings.build(:body => 'foo', :headline => 'meh')
      @o.expects(:deliver_notification)
    end

    should "call deliver" do
      assert @o.new_record?
      assert @o.save
    end
  end
end
