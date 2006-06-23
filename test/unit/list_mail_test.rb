require File.dirname(__FILE__) + '/../test_helper'

class ListMailTest < Test::Unit::TestCase
  fixtures :list_mails

  # Replace this with your real tests.
  def test_truth
    assert_kind_of ListMail, list_mails(:list_mails_1)
  end

end
