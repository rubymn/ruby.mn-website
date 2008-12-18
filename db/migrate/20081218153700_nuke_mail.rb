class NukeMail < ActiveRecord::Migration
  def self.up
    drop_table :list_mails
    remove_column :openings, :type
  end

  def self.down
  end
end
