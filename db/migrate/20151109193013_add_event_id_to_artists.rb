class AddEventIdToArtists < ActiveRecord::Migration
  def change
    add_column :artists, :event_id, :integer

    drop_table :artists_events
  end
end
