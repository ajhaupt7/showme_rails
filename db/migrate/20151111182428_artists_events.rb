class ArtistsEvents < ActiveRecord::Migration
  def change
    create_table :artists_events do |t|
      t.integer :artist_id
      t.integer :event_id

      t.timestamps
    end
  end
end
