require 'rspotify'
require 'rest_client'

module Api
  def search_spotify(query)
    puts "Query: #{query}"
    result = nil
    begin
      artists = RSpotify::Artist.search(query)
      found_artist = artists.first
      if found_artist.top_tracks(:US) != []
        result = found_artist
      end
    rescue => e
      puts "Caught #{e}"
    end
    puts "#{result} at the end"
    return result
  end

  def search_bandsintown(date, city, state)
    found_events = []
      begin
        base_url = "http://api.bandsintown.com/events/search.json?api_version=2.0&app_id=#{ENV['BANDSINTOWN_ID']}&date=#{date}&location=#{city},#{state}"
        unclean = RestClient.get(base_url)
        events = JSON.parse(unclean)

        found_artist = nil

        events.each do |event|
          new_event = Event.new
          new_event.datetime = DateTime.parse(event['datetime'])
          new_event.ticket_url = event['ticket_url']
          new_event.venue_name = event['venue']['name']
          new_event.venue_lat = event['venue']['latitude']
          new_event.venue_long = event['venue']['longitude']
          new_event.save

          event['artists'].each do |artist|
          artist['name'].sub!('+', "Plus")
          spotify_search_result = search_spotify(artist['name'])
            if spotify_search_result != nil && event['ticket_status'] == 'available'
              new_artist = Artist.new
              new_artist.name = spotify_search_result.name
              new_artist.song_preview = spotify_search_result.top_tracks(:US).first.preview_url
              if spotify_search_result.images[0]['url']
                new_artist.image_url = spotify_search_result.images[0]['url']
              elsif spotify_search_result.top_tracks(:US)[0].album.images[0]['url']
                new_artist.image_url = spotify_search_result.top_tracks(:US)[0].album.images[0]['url']
              else
                new_artist.image_url = nil
              end
              new_artist.save
              new_event.artists << new_artist
              artist['preview'] = spotify_search_result.top_tracks(:US).first.preview_url
              if !found_events.include?(event)
                found_events.push(event)
              end
            end
          end
        end
      rescue => e
        puts "Something went terribly wrong :( #{e}"
        return false
      end
    return found_events
  end
end
