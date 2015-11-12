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
    city.downcase!
    found_events = []
      begin
      # Timeout::timeout(15) {
        base_url = "http://api.bandsintown.com/events/search.json?api_version=2.0&app_id=#{ENV['BANDSINTOWN_ID']}&date=#{date}&location=#{city},#{state}"
        unclean = RestClient.get(base_url)
        events = JSON.parse(unclean)

        if events == []
          return false
        end

        if CityDate.find_by(date: date, city: city, state:state)
          city_date = CityDate.find_by(date: date, city: city, state:state)
        else
          city_date = CityDate.create(date: date, city: city, state:state)
        end

        found_artist = nil

        events.each do |event|
          if event['ticket_status'] == 'available' && Event.find_by(bandsintown_id:event['id']) == nil
            new_event = Event.create(datetime:DateTime.parse(event['datetime']), ticket_url:event['ticket_url'], venue_name:event['venue']['name'], venue_lat:event['venue']['latitude'], venue_long:event['venue']['longitude'], bandsintown_id:event['id'])
            city_date.events << new_event

            event['artists'].each do |artist|
              artist['name'].sub!('+', "Plus")
              spotify_search_result = search_spotify(artist['name'])
                if spotify_search_result != nil
                  if (Artist.find_by(song_preview:spotify_search_result.top_tracks(:US).first.preview_url) != nil)
                    retrieved_artist = Artist.find_by(song_preview:spotify_search_result.top_tracks(:US).first.preview_url)
                    new_event.artists << retrieved_artist unless new_event.artists.include?(retrieved_artist)
                  else
                    new_artist = Artist.new(name: artist['name'], song_preview:spotify_search_result.top_tracks(:US).first.preview_url, spotify_link:spotify_search_result.top_tracks(:US).first.external_urls['spotify'])
                    if spotify_search_result.images != []
                      new_artist.image_url = spotify_search_result.images[0]['url']
                    elsif spotify_search_result.top_tracks(:US)[0].album.images != []
                      new_artist.image_url = spotify_search_result.top_tracks(:US)[0].album.images[0]['url']
                    else
                      new_artist.image_url = nil
                    end
                    new_artist.save
                    new_event.artists << new_artist
                  end
                  if !found_events.include?(event)
                    found_events.push(event)
                  end
                end
            end
            new_event.destroy if !new_event.artists.any?
          end
        end
      # }
      rescue Timeout::Error => e
        puts "Timeout #{e}"
      rescue => e
        puts "Something went terribly wrong: #{e}"
        return false
      end
      return found_events
  end

  def city_events_month(city, state)
    current_date = DateTime.now
    input_date = current_date.strftime("%Y-%m-%d")
    i = 0
    while i < 31
      search_bandsintown(input_date, city, state)
      i += 1
      current_date = DateTime.now + i
      input_date = current_date.strftime("%Y-%m-%d")
    end
  end

  def biggest_cities_events
    city_events_month("seattle", "WA")
    city_events_month("new york", "NY")
    city_events_month("los angeles", "CA")
    city_events_month("chicago", "IL")
    city_events_month("houston", "TX")
    city_events_month("philadelphia", "PA")
    city_events_month("phoenix", "AR")
    city_events_month("san antonio", "TX")
    city_events_month("san diego", "CA")
    city_events_month("dallas", "TX")
    city_events_month("san jose", "CA")
    city_events_month("austin", "TX")
    city_events_month("jacksonville", "FL")
    city_events_month("san francisco", "IN")
    city_events_month("columbus", "OH")
    city_events_month("fort worth", "TX")
    city_events_month("charlotte", "NC")
    city_events_month("detroit", "MI")
    city_events_month("el paso", "TX")
    city_events_month("denver", "CO")
    city_events_month("washington", "DC")
    city_events_month("memphis", "TN")
    city_events_month("boston", "MA")
    city_events_month("nashville", "TN")
    city_events_month("baltimore", "MD")
    city_events_month("oklahoma city", "OK")
    city_events_month("portland", "OR")
    city_events_month("las vegas", "NV")
    city_events_month("kansas city", "MO")
    city_events_month("atlanta", "GA")
    city_events_month("omaha", "NE")
    city_events_month("raleigh", "NC")
    city_events_month("minneapolis", "MN")
    city_events_month("new orleans", "LA")
    city_events_month("milwaukee", "WI")
  end

  # def update_events
  #   CityDate.all.each do |city_date|
  #     city_date.events
  #   end
  # end
end
