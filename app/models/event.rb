class Event < ActiveRecord::Base
  # Associations
  belongs_to :user
  has_and_belongs_to_many :amenities
  has_many :event_registrations
  has_many :users, :through => :event_registrations

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
