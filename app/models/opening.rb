class Opening < ActiveRecord::Base
  belongs_to :user
  after_create :deliver_notification
  validates_presence_of :body, :headline

  def deliver_notification
      Notifier.deliver_notify_opening(self)
  end
end
