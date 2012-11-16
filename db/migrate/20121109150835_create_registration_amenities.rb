class CreateRegistrationAmenities < ActiveRecord::Migration
  def change
    create_table :registration_amenities do |t|
      t.integer :amenities_event_id
      t.integer :event_registration_id

      t.timestamps
    end
  end
end
