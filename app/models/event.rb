# == Schema Information
#
# Table name: events
#
#  id             :integer          not null, primary key
#  created_at     :datetime
#  scheduled_time :datetime
#  headline       :string(200)      default(""), not null
#  body           :text             not null
#  user_id        :integer          default(0), not null
#  approved       :boolean          default(FALSE)
#

class Event < ActiveRecord::Base
  # Associations
  belongs_to :user

  # Validations
  validates :headline,       :presence => true
  validates :scheduled_time, :presence => true
  validates :body,           :presence => true
  validates :user_id,        :presence => true

  # Scopes
  scope :approved, includes(:user).where(:approved => true).limit(5)
  scope :unapproved, where(:approved => false)
  scope :order_scheduled_time_desc, order('scheduled_time desc')

  def formatted_scheduled_time
    self.scheduled_time.try(:to_s, :jquery_datepicker)
  end

  def formatted_scheduled_time=(unformatted_time)
    self.scheduled_time = Chronic.parse(unformatted_time.to_s)
  end

  def unapproved?
    !approved?
  end
end
