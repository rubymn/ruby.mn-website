class AddBeard < ActiveRecord::Migration
  def self.up
    add_column :users, :beard_file_name, :string
    add_column :users, :beard_content_type, :string, :limit => 60
    add_column :users, :beard_updated_at, :datetime
    add_column :users, :beard_file_size, :integer
  end

  def self.down
  end
end
