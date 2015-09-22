# == Schema Information
#
# Table name: projects
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  title       :string(255)
#  url         :string(255)
#  source_url  :string(255)
#  description :text
#  created_at  :datetime
#  updated_at  :datetime
#

class Project < ActiveRecord::Base
  HUMANIZED_COLUMNS = { :url => 'URL' }
  belongs_to :user

  validates :title,       :presence => true
  validates :description, :presence => true
  validates :url,         :presence => true
  validates :user_id,     :presence => true

  # rename a couple of the attribute names in the form labels
  def self.human_attribute_name(name, options = {})
    HUMANIZED_COLUMNS[name] || super
  end
end
