class OpeningsCat < ActiveRecord::Migration
  def self.up
    add_column :openings, :created_at, :datetime
  end

  def self.down
    remove_column :openings, :created_at, :datetime
  end
end
