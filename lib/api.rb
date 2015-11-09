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
          binding.pry
          event['artists'].each do |artist|
          artist['name'].sub!('+', "Plus")
          spotify_search_result = search_spotify(artist['name'])
            if spotify_search_result != nil && event['ticket_status'] == 'available'
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
