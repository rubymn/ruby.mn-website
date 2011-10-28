# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  include ReCaptcha::ViewHelper

  def markdown(text)
    RDiscount.new(text).to_html
  end

  def mup(text)
    auto_link(markdown(text))
  end

  def i_am user
    session[:uid] == user.id
  end

  def get_captcha
    k = ReCaptcha::Client.new(ENV['RCC_PUB'], ENV['RCC_PRIV'])
    r = k.get_challenge(session[:rcc_err] || '' )
    session[:rcc_err] = ''
    r
  end
end
