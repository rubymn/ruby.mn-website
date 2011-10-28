class SignupMailer < ActionMailer::Base
  def confirm(user)
    @subject     = "RUM Signup Confirmation"
    @recipients  = [user.email]
    @from        = ADMIN_ADDRESS
    @body[:user] = user
  end

  def pass_inst(user)
    @subject     = "RUM Password Change"
    @recipients  = [user.email]
    @body[:user] = user
  end
end
