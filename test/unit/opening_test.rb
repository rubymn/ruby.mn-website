require 'test_helper'

class OpeningTest < ActiveSupport::TestCase
  should_belong_to :user
  should_validate_presence_of :body, :headline
  context "an instance" do
    setup {
      @u = Factory.create(:user)
      @o = @u.openings.build(:body=>'foo', :headline=>'meh')
      @o.expects(:deliver_notification)
    }
    should "call deliver" do
      assert @o.new_record?
      assert @o.save
    end
  end
end
