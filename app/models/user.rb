class User < ActiveRecord::Base
  include LoginEngine::AuthenticatedUser
  has_many :events
  has_many :openings
  has_and_belongs_to_many :books, :join_table=>'users_books'
end
