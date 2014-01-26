class Sponsor < ActiveRecord::Base
  attr_accessible :contact_email, :contact_url, :current, :description, :logo_image_large, :logo_image_small, :name, :phone
end
