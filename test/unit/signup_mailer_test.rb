require 'test_helper'

class SignupMailerTest < ActionMailer::TestCase

  def test_signup_mail
    u = Factory.create(:user)
    u.generate_security_token
    res = SignupMailer.confirm(u)
    assert_equal "RUM Signup Confirmation", res.subject
    assert_equal ADMIN_ADDRESS, res.from[0]
    assert_equal u.email, res.to[0]
    assert_match /#{u.security_token}/, res.body.to_s

  end

end
