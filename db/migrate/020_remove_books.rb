class RemoveBooks < ActiveRecord::Migration
  def self.up
    drop_table :books
  end

  def self.down
    create_table :books
  end
end
