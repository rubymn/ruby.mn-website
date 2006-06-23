class User < ActiveRecord::Base
  has_many :events
  has_many :openings
  include LoginEngine::AuthenticatedUser
end
