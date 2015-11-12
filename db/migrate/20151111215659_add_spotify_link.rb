class AddSpotifyLink < ActiveRecord::Migration
  def change
    add_column :artists, :spotify_link, :string
  end
end
