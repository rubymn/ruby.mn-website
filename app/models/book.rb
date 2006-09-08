class Book < ActiveRecord::Base
  has_and_belongs_to_many :users, :join_table=>'users_books'
  validates_presence_of [:title, :description, :author, :isbn]
end
