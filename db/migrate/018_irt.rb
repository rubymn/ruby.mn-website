class Irt < ActiveRecord::Migration
  def self.up
    add_column :list_mails, :irt, :string, :limit=>200
  end

  def self.down
    remove_column :list_mails, :irt
  end
end
