require File.dirname(__FILE__) + '/../test_helper'

class LinkTest < Test::Unit::TestCase
  fixtures :links

  # Replace this with your real tests.
  def test_truth
    assert_kind_of Link, links(:first)
  end
end
