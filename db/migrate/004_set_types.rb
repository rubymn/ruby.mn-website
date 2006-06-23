class SetTypes < ActiveRecord::Migration
  def self.up

      change_column :links, :clicked, :integer, :default=>0
      change_column :links, :score,  :integer, :default=>0
  end

  def self.down
  end
end
