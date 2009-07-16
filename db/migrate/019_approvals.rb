class Approvals < ActiveRecord::Migration
  def self.up
    add_column :events, :approved, :boolean, :default=>false
  end

  def self.down
    add_column :events, :approved
  end
end
