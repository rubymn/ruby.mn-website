class LoggedInAt < ActiveRecord::Migration
  def self.up
    add_column :users, :logged_in_at, :datetime
  end

  def self.down
    remove_column :users, :logged_in_at
  end
end
