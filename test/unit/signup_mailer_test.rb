require File.dirname(__FILE__) + '/../test_helper'

class SignupMailerTest < Test::Unit::TestCase
  FIXTURES_PATH = File.dirname(__FILE__) + '/../fixtures'
  CHARSET = "utf-8"

  fixtures :users
  include ActionMailer::Quoting

  def setup
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
    @expected = TMail::Mail.new
    @expected.set_content_type "text", "plain", { "charset" => CHARSET }
    @expected.mime_version = '1.0'
    @user = users(:bob)
  end

  def test_signup_mail
    @user.generate_security_token
    res = SignupMailer.create_confirm(@user)
    assert_equal "RUM Signup Confirmation", res.subject
    assert_equal "ruby.mn@ruby.mn", res.from[0]
    assert_equal @user.email, res.to[0]
    assert_match /#{@user.security_token}/, res.body

  end

  private
    def encode(subject)
      quoted_printable(subject, CHARSET)
    end
end
