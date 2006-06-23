class Link < ActiveRecord::Base
    attr_accessible :description, :url, :title
    belongs_to :user
end
