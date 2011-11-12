class Opening < ActiveRecord::Base
  after_create :deliver_notification

  belongs_to :user

  validates :body,     :presence => true
  validates :headline, :presence => true

  protected

    def deliver_notification
      Notifier.notify_opening(self).deliver
    end
end
