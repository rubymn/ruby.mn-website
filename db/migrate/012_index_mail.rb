class IndexMail < ActiveRecord::Migration
  def self.up
    change_column :list_mails, :mailid, :string, :limit=>100
    execute 'create index maild_idx on list_mails(mailid(5))'
  end

  def self.down
    execute 'drop index maild_idx on list_mails'
    change_column :list_mails, :mailid, :text
  end
end
