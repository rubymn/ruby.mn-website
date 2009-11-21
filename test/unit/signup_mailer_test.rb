require 'test_helper'

class SignupMailerTest < ActionMailer::TestCase

  def test_signup_mail
    u = Factory.create(:user)
    u.generate_security_token
    res = SignupMailer.create_confirm(u)
    assert_equal "RUM Signup Confirmation", res.subject
    assert_equal "ruby.mn@ruby.mn", res.from[0]
    assert_equal u.email, res.to[0]
    assert_match /#{u.security_token}/, res.body

  end

end
