module ApplicationHelper
  def markdown(text)
    RDiscount.new(text).to_html
  end

  def mup(text)
    auto_link(markdown(text))
  end

  def i_am user
    session[:uid] == user.id
  end
end
