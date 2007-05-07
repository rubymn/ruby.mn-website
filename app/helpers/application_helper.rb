# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper


  def mup(text)
    markdown(auto_link(h(text)))

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
    User.find(session[:uid]) if session[:uid]
  end
end
