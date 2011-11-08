class SignupMailer < ActionMailer::Base
  default :from => ADMIN_ADDRESS

  def confirm(user)
    @user = user
    mail(:to => "#{user.full_name} <#{user.email}>", :subject => "RUM Signup Confirmation")
  end

  def pass_inst(user)
    @user = user
    mail(:to => "#{user.full_name} <#{user.email}>", :subject => "RUM Password Change")
  end
end