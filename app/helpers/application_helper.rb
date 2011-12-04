module ApplicationHelper
  def markdown(text)
    RDiscount.new(text).to_html
  end

  def mup(text)
    auto_link(markdown(text))
  end

  def i_am(user)
    session[:uid] == user.id
  end

  def emdash
    '&mdash;'.html_safe
  end

  def user_gravatar(user)
    gravatar_url user.gravatar_email, :size => 80
  end
end
