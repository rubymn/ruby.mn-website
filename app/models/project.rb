class Project < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :title, :description, :url, :user_id
end
