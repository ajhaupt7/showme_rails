require 'rspotify'
require 'rest_client'

module Api
  def search_spotify(query)
    puts "Query: #{query}"
    result = nil
    begin
      artists = RSpotify::Artist.search(query)
      found_artist = nil
      artists.each do |artist|
        if artist.name.downcase == query
          found_artist = artist
          break
        end
      end
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
              spotify_search_result = search_spotify(artist['name'].downcase)
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
    while i < 15
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
    city_events_month("phoenix", "AZ")
    city_events_month("san antonio", "TX")
    city_events_month("san diego", "CA")
    city_events_month("dallas", "TX")
    city_events_month("san jose", "CA")
    city_events_month("austin", "TX")
    city_events_month("jacksonville", "FL")
    city_events_month("indianapolis", "IN")
    city_events_month("san francisco", "CA")
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

  def update_biggest_cities
    search_bandsintown(Date.today + 14, "seattle", "WA")
    search_bandsintown(Date.today + 14, "new york", "NY")
    search_bandsintown(Date.today + 14, "los angeles", "CA")
    search_bandsintown(Date.today + 14, "chicago", "IL")
    search_bandsintown(Date.today + 14, "houston", "TX")
    search_bandsintown(Date.today + 14, "philadelphia", "PA")
    search_bandsintown(Date.today + 14, "phoenix", "AZ")
    search_bandsintown(Date.today + 14, "san antonio", "TX")
    search_bandsintown(Date.today + 14, "san diego", "CA")
    search_bandsintown(Date.today + 14, "dallas", "TX")
    search_bandsintown(Date.today + 14, "san jose", "CA")
    search_bandsintown(Date.today + 14, "austin", "TX")
    search_bandsintown(Date.today + 14, "jacksonville", "FL")
    search_bandsintown(Date.today + 14, "indianapolis", "IN")
    search_bandsintown(Date.today + 14, "san francisco", "CA")
    search_bandsintown(Date.today + 14, "columbus", "OH")
    search_bandsintown(Date.today + 14, "fort worth", "TX")
    search_bandsintown(Date.today + 14, "charlotte", "NC")
    search_bandsintown(Date.today + 14, "detroit", "MI")
    search_bandsintown(Date.today + 14, "el paso", "TX")
    search_bandsintown(Date.today + 14, "denver", "CO")
    search_bandsintown(Date.today + 14, "washington", "DC")
    search_bandsintown(Date.today + 14, "memphis", "TN")
    search_bandsintown(Date.today + 14, "boston", "MA")
    search_bandsintown(Date.today + 14, "nashville", "TN")
    search_bandsintown(Date.today + 14, "baltimore", "MD")
    search_bandsintown(Date.today + 14, "oklahoma city", "OK")
    search_bandsintown(Date.today + 14, "portland", "OR")
    search_bandsintown(Date.today + 14, "las vegas", "NV")
    search_bandsintown(Date.today + 14, "kansas city", "MO")
    search_bandsintown(Date.today + 14, "atlanta", "GA")
    search_bandsintown(Date.today + 14, "omaha", "NE")
    search_bandsintown(Date.today + 14, "raleigh", "NC")
    search_bandsintown(Date.today + 14, "minneapolis", "MN")
    search_bandsintown(Date.today + 14, "new orleans", "LA")
    search_bandsintown(Date.today + 14, "milwaukee", "WI")
  end

  def update_events
    biggest_cities = %w(seattle milwaukee new\ orleans minneapolis raleigh omaha atlanta kansas\ city las\ vegas portland oklahoma\ city baltimore nashville boston memphis washington denver el\ paso detroit charlotte fort\ worth columbus san\ francisco indianapolis jacksonville austin san\ jose dallas san\ antonio san\ diego phoenix philadelphia houston chicago los\ angeles new\ york)
    CityDate.all.each do |city_date|
      if city_date.date < Date.today || !biggest_cities.include?(city_date.city.downcase)
        city_date.destroy
        puts city_date.date + " " + city_date.city
      else
        update_events_search(city_date.date, city_date.city, city_date.state)
      end
    end
    update_biggest_cities
  end

  def update_events_search(date, city, state)
    city.downcase!
      begin
        base_url = "http://api.bandsintown.com/events/search.json?api_version=2.0&app_id=#{ENV['BANDSINTOWN_ID']}&date=#{date}&location=#{city},#{state}"
        unclean = RestClient.get(base_url)
        events = JSON.parse(unclean)

        if events == []
          return false
        end

        city_date = CityDate.find_by(date: date, city: city, state:state)

        found_artist = nil

        events.each do |event|
          if Event.find_by(bandsintown_id:event['id']) != nil
            Event.find_by(bandsintown_id:event['id']).destroy if event['ticket_status'] == 'unavailable'
            binding.pry

          elsif event['ticket_status'] == 'available' && Event.find_by(bandsintown_id:event['id']) == nil
            binding.pry
            new_event = Event.create(datetime:DateTime.parse(event['datetime']), ticket_url:event['ticket_url'], venue_name:event['venue']['name'], venue_lat:event['venue']['latitude'], venue_long:event['venue']['longitude'], bandsintown_id:event['id'])
            city_date.events << new_event

            event['artists'].each do |artist|
              spotify_search_result = search_spotify(artist['name'].downcase)
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
      rescue => e
        puts "Something went terribly wrong: #{e}"
        return false
      end
  end

  def clean_artists_database
    Artist.all.each do |artist|
      if artist.events == []
        artist.destroy
      end
    end
  end
end
