class IndexMail < ActiveRecord::Migration
  def self.up
    change_column :list_mails, :mailid, :string, :limit=>100
    add_index :list_mails, :mailid
  end

  def self.down
    remove_index :list_mails, :mailid
    change_column :list_mails, :mailid, :text
  end
end
