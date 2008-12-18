require File.dirname(__FILE__) + '/../test_helper'

class ForHireTest < Test::Unit::TestCase
  fixtures :users,:for_hires

  # Replace this with your real tests.
  def test_creation
    fh = ForHire.new({:user=>users(:bob), :blurb=>'foo', :email=>'bar'})
    assert_not_nil fh
    assert_equal users(:bob), fh.user
    assert_equal fh.blurb, 'foo'
    assert_equal fh.email, 'bar'
  end
  def test_has_title
    assert ForHire.find(for_hires(:first).id).title

  end
end
