class NukeMail < ActiveRecord::Migration
  def self.up
    begin
    drop_table :list_mails
    remove_column :openings, :type
    rescue 
    end
  end

  def self.down
  end
end
