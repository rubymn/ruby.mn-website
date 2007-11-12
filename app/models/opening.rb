class Opening < ActiveRecord::Base
  belongs_to :user
  after_create :deliver_notification

  def deliver_notification
      Notifier.deliver_notify_opening(self)
  end
end
