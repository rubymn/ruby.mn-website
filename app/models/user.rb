class User < ActiveRecord::Base
  include LoginEngine::AuthenticatedUser
  has_many :events
  has_many :openings
  has_many :books
end
