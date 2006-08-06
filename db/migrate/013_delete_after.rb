class DeleteAfter < ActiveRecord::Migration
  def self.up
    add_column :users, :delete_after, :date
    add_column :users, :role, :string, :limit=>10
  end

  def self.down
    remove_column :users, :delete_after
    remove_column :users, :role
  end
end
