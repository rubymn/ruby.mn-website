# == Schema Information
#
# Table name: openings
#
#  id         :integer          not null, primary key
#  created_at :datetime
#  headline   :string(100)      default(""), not null
#  body       :text             not null
#  user_id    :integer
#

class Opening < ActiveRecord::Base
  after_create :deliver_notification

  belongs_to :user

  validates :body,     :presence => true
  validates :headline, :presence => true

  paginates_per 10

  protected

    def deliver_notification
      Notifier.notify_opening(self).deliver
    end
end
