class Notifier < ActionMailer::Base
  default :from => NOTIFICATION_ADDRESS

  def notify_opening(opening)
    @opening = opening
    mail(:to => TCRBB_LIST_ADDRESS, :subject => "New Opening Posted: #{@opening.headline}")
  end

  def notify_event(event)
    @event = event
    mail(:to => TCRBB_LIST_ADDRESS, :subject => @event.headline)
  end
end
