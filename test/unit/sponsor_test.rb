# == Schema Information
#
# Table name: sponsors
#
#  id               :integer          not null, primary key
#  name             :string(255)
#  logo_image_small :string(255)
#  logo_image_large :string(255)
#  phone            :string(255)
#  description      :text
#  contact_email    :string(255)
#  contact_url      :string(255)
#  current          :boolean
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require 'test_helper'

class SponsorTest < ActiveSupport::TestCase
  subject { Factory.create :sponsor }
end
