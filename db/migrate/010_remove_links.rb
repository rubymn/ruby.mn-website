class RemoveLinks < ActiveRecord::Migration
  def self.up
    drop_table :links
  end

  def self.down
    raise "Irreversible migration exception"
  end
end
