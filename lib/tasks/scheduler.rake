task :load_all_cities => :environment do
  biggest_cities_events
end

task :load_artist_spotify_previews => :environment do
  load_artist_spotify_previews
end
