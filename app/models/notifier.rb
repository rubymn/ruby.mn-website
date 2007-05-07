class Notifier < ActionMailer::Base

  def notify_opening(opening)
    @subject="New Opening Posted: #{opening.headline}"
    @recipients=TCRBB_LIST_ADDRESS
    @from = "notifications@ruby.mn"
    @body[:o]=opening

  end

  def notify_event(event)
    @subject = "New Event Posted"
    @recipients="m@loonsoft.com"
    @from="notifications@ruby.mn"
    @body[:e]=event
  end
end
