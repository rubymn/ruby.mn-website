class LinkTitle < ActiveRecord::Migration
  def self.up
      add_column :links, :user_id, :integer
      add_column :links, :title, :string, :maxlength=>150
  end

  def self.down
  end
end
