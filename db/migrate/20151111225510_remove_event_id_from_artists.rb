class RemoveEventIdFromArtists < ActiveRecord::Migration
  def change
    remove_column :artists, :event_id
  end
end
