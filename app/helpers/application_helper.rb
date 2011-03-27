# Methods added to this helper will be available to all templates in the application.
require 'recaptcha'
module ApplicationHelper
  include ReCaptcha::ViewHelper
  def mup(text)
    auto_link(markdown(text))

  end

  def i_am user
    session[:uid] == user.id
  end

  # def current_user
  #   puts "in ApplicationHelper#current_user"
  #   
  #   if session[:uid] and @uuu.nil?
  #     @uuu = User.find(session[:uid])
  #   end
  #   @uuu
  # end

  def get_captcha()
    k = ReCaptcha::Client.new(ENV['RCC_PUB'], ENV['RCC_PRIV'])
    r = k.get_challenge(session[:rcc_err] || '' )
    session[:rcc_err]=''
    r
  end
end
