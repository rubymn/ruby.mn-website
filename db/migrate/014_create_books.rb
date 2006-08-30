class CreateBooks < ActiveRecord::Migration
  def self.up
    create_table :books do |t|
      t.column :title, :string, :limit=>100, :null=>false
      t.column :author, :string, :limit=>100, :null=>false
      t.column :isbn, :string, :limit=>30, :null=>false
      t.column :description, :text
      t.column :user_id, :int, :null=>false
    end
  end

  def self.down
    drop_table :books
  end
end
