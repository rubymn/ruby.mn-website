class Treemail < ActiveRecord::Migration
  def self.up
    drop_table :messages_messages
    add_column :list_mails, :parent_id, :integer
  end

  def self.down
    raise IrreversibleMigration
  end
end
