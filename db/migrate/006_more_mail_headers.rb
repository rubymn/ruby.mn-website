class MoreMailHeaders < ActiveRecord::Migration

  def self.up
    create_table :messages_messages, :id=>false do |t|
      t.column :parent_id, :integer, :null=>false
      t.column :child_id, :integer, :null=>false
    end
    add_column :list_mails, :mailid, :string, :limit=>256, :null=>false, :default=>''
    
  end

  def self.down
    drop_table :messages_messages
    remove_column :list_mails, :mailid
  end
end
