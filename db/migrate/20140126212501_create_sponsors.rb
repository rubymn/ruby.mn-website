class CreateSponsors < ActiveRecord::Migration
  def change
    create_table :sponsors do |t|
      t.string :name
      t.string :logo_image_small
      t.string :logo_image_large
      t.string :phone
      t.text :description
      t.string :contact_email
      t.string :contact_url
      t.boolean :current

      t.timestamps
    end
  end
end
