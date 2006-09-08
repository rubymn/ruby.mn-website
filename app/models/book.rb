class Book < ActiveRecord::Base
  belongs_to :user
  validates_presence_of [:title, :description, :author, :isbn]
end
