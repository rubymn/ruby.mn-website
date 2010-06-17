class Notifier < ActionMailer::Base

  def notify_opening(opening)
    @subject="New Opening Posted: #{opening.headline}"
    @recipients=TCRBB_LIST_ADDRESS
    @from = NOTIFICATION_ADDRESS
    @body[:o]=opening

  end

  def notify_event(event)
    @subject = "New Event Posted"
    @recipients = ADMIN_ADDRESS
    @from = NOTIFICATION_ADDRESS
    @body[:e]=event
  end
end
