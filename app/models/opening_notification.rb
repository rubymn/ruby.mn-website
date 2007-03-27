class OpeningNotification < ActionMailer::Base

  def notify(opening)
    @subject="New Opening Posted: #{opening.headline}"
    @recipients=TCRBB_LIST_ADDRESS
    @from = "notifications@ruby.mn"
    @body[:o]=opening

  end
end
