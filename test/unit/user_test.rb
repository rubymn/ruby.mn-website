require 'test_helper'

class UserTest < ActiveSupport::TestCase
  subject {Factory.create :user}
  should_have_one :for_hire
  should_have_many :events
  should_have_many :openings
  should_have_many :projects
  should_have_attached_file :beard
  should_validate_presence_of  :login
  should_validate_uniqueness_of :login, :email

  context "no beardos" do
    should "sadly know how to calculate the bearddex" do
      assert_not_nil User.calc_bdx
      assert_equal 0, User.calc_bdx
    end
  end
  have_named_scope :beardos
  context "with some beardos" do
    setup do 
      @b = Factory.create :beardo
      assert_not_nil @b.beard_file_name
      assert_equal 1,  User.beardos.count
      @u = Factory.create :user
      assert_nil @u.beard_file_name
    end 
    should "have some beardos" do
      assert  User.beardos.count >= 1
    end
    should "smoo how to calculate the bearddex" do
      assert  User.beardos.count >= 1
      assert_not_nil User.calc_bdx
      assert_equal 50.0, User.calc_bdx
    end
  end
end
