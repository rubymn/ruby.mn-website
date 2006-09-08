class Usersbooks < ActiveRecord::Migration
  def self.up
    create_table :users_books, :id=>false do |t|
      t.column :user_id, :int, :null=>false
      t.column :book_id, :int, :null=>false
    end
    remove_column :books, :user_id
  end


  def self.down
    drop_table :users_books
    add_column :books, :user_id, :int
  end
end
