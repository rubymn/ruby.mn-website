class SignupMailer < ActionMailer::Base
  def confirm(user)
    @subject = "RUM Signup Confirmation"
    @recipients=[user.email]
    @from = "ruby.mn@ruby.mn"
    @body[:user]=user
  end
end
