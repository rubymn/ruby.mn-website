class AddLinkTable < ActiveRecord::Migration
  def self.up
      create_table :links do |t|
          t.column :description, :string, :maxlength=>"254"
          t.column :url, :string
          t.column :score , :integer
          t.column :clicked, :integer 
      end
      Link.create :description=>'test', :url=>'http://www.slashdot.org', :score=>1, :clicked=>3

  end

  def self.down
      drop_table :links
  end
end
