class CreateAmenitiesEvents < ActiveRecord::Migration
  def up
    create_table :amenities_events do |t|
      t.integer :event_id
      t.integer :amenity_id

      t.timestamps
    end
  end

end
