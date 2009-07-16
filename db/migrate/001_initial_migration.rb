class InitialMigration < ActiveRecord::Migration
  def self.up
    create_table :for_hires do |t|
      t.column :blurb, :text,:null=>false
      t.column :created_at, :datetime, :null=>false
      t.column :email, :string, :null=>false, :limit=>200
      t.column :title , :string, :null=>false, :limit=>200
      t.column :user_id, :integer, :null=>false
    end

    create_table :openings do |t|
      t.column :created_at, :datetime, :null=>false
      t.column :body, :text, :null=>false
      t.column :headline, :string, :limit=>200, :null=>false
      t.column :type, :string, :limit=>50, :null=>false
      t.column :user_id, :integer, :null=>false
    end
    create_table :events do |t|
      t.column :created_at, :datetime, :null=>false
      t.column :scheduled_time, :datetime, :null=>false
      t.column :headline, :string, :limit=>200, :null=>false
      t.column :body, :text, :null=>false
      t.column :user_id, :integer, :null=>false
    end
    create_table :users do |t|
      t.column :login, :string, :limit=>80, :null=>false
      t.column :salted_password, :string, :limit=>80, :null=>false
      t.column :email, :string, :limit=>100, :null=>false
      t.column :firstname, :string, :limit=>100, :null=>false
      t.column :lastname, :string, :limit=>100, :null=>false
      t.column :salt, :string, :limit=>40, :null=>false
      t.column :verified, :boolean, :null=>false, :default=>false
      t.column :security_token, :string, :limit=>40
      t.column :token_expiry, :datetime
      t.column :deleted, :boolean, :default=>false
    end

  end

  def self.down
    drop_table :for_hires
    drop_table :openings
    drop_table :events
    drop_table :users
  end
end
