class ListMail < ActiveRecord::Base
  acts_as_tree  :order=>'stamp'
end
