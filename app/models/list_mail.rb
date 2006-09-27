class ListMail < ActiveRecord::Base
  acts_as_nested_set :scope=>:root

  def before_create
    # Update the child object with its parents attrs
    unless self[:parent_id].to_i.zero?
      self[:depth] = parent[:depth].to_i + 1
      self[:root_id] = parent[:root_id].to_i
    end
  end
  def after_create
    # Update the parent root_id with its id
    if self[:parent_id].to_i.zero?
      self[:root_id] = self[:id]
      self.save
    else
      parent.add_child self
    end
    if self[:lft] == nil and self[:rgt]== nil
      self[:lft]=0
      self[:rgt]=0
      save!
    end
  end

  def parent
    @parent ||= self.class.find(self[:parent_id])
  end
end
