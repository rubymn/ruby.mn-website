class Approvals < ActiveRecord::Migration
  def self.up
    add_column :events, :approved, :boolean, :default=>0
  end

  def self.down
    add_column :events, :approved
  end
end
