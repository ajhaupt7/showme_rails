class AddTrackName < ActiveRecord::Migration
  def change
    add_column :artists, :song_name, :string
  end
end
