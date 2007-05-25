# Methods added to this helper will be available to all templates in the application.
require 'recaptcha'
module ApplicationHelper
  def mup(text)
    auto_link(markdown(text))

  end

  def doctype_header
    "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01//EN\" \"http://www.w3.org/TR/html4/strict.dtd\">"
  end

  def encoding
    %q%<META http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">%
  end

  def i_am user
    session[:uid] == user.id
  end

  def current_user
    if session[:uid] and @uuu.nil?
      @uuu = User.find(session[:uid])
    end
    @uuu
  end

  def get_captcha()
    k = ReCaptchaClient.new(RCC_PUB, RCC_PRIV)
    r = k.get_challenge(session[:rcc_err] || '' )
    session[:rcc_err]=''
    r
  end
end
