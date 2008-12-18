class Redo < ActiveRecord::Migration
  def self.up
    remove_column :messages_messages, :parent_id
    add_column :messages_messages, :list_mail_id, :integer, :null=>false, :default=>''
  end

  def self.down
  end
end
