class Nested < ActiveRecord::Migration
  def self.up
    add_column :list_mails, :root_id, :integer
    add_column :list_mails, :lft, :integer
    add_column :list_mails, :rgt, :integer
    add_column :list_mails, :depth, :integer
  end

  def self.down
    remove_column :list_mails, :root_id
    remove_column :list_mails, :lft
    remove_column :list_mails, :rght
    remove_column :list_mails, :depth
  end
end
