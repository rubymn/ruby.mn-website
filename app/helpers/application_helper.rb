# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper


  def mup(text)
    markdown(auto_link(h(text)))

  end

  def i_am user
    session[:user] == user
  end

  def current_user
    session[:user]
  end
end
