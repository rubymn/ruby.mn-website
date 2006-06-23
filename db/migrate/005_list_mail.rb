class ListMail < ActiveRecord::Migration
  def self.up

    create_table :list_mails do |t|
      t.column :subject, :string, :limit=>256, :null=>false
      t.column :replyto, :string, :limit=>256
      t.column :from, :string, :limit=>128, :null=>false
      t.column :to, :string, :limit=>128, :null=>false;
      t.column :stamp, :datetime, :null=>false
      t.column :body, :text, :null=>false
    end

  end

  def self.down
    drop_table :list_mails
  end
end
