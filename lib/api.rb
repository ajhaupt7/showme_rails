require 'rspotify'
require 'rest_client'

module Api
  def search_spotify(query)
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
    while i < 31
      search_bandsintown(input_date, city, state)
      i += 1
      current_date = DateTime.now + i
      input_date = current_date.strftime("%Y-%m-%d")
    end
  end

  @@biggest_cities = [ ["seattle", "WA"], ["new york", "NY"], ["los angeles", "CA"], ["chicago", "IL"], ["houston", "TX"], ["philadelphia", "PA"], ["phoenix", "AZ"], ["san antonio", "TX"], ["san diego", "CA"], ["dallas", "TX"], ["san jose", "CA"], ["austin", "TX"], ["jacksonville", "FL"], ["indianapolis", "IN"], ["san francisco", "CA"], ["columbus", "OH"], ["fort worth", "TX"], ["charlotte", "NC"], ["detroit", "MI"], ["el paso", "TX"], ["denver", "CO"], ["washington", "DC"], ["memphis", "TN"], ["boston", "MA"], ["nashville", "TN"], ["baltimore", "MD"], ["oklahoma city", "OK"], ["portland", "OR"], ["las vegas", "NV"], ["kansas city", "MO"], ["atlanta", "GA"], ["omaha", "NE"], ["raleigh", "NC"], ["minneapolis", "MN"], ["new orleans", "LA"], ["milwaukee", "WI"] ]

  def biggest_cities_events
    @@biggest_cities.each do |city|
      city_events_month(city[0], city[1])
    end
  end

  def biggest_cities_next_day
    @@biggest_cities.each do |city|
      search_bandsintown(DateTime.now + 30, city[0], city[1])
    end
  end

  def update_events
    CityDate.all.each do |city_date|
      begin
        if city_date.date < Date.today || !@@biggest_cities.include?([city_date.city, city_date.state])
          city_date.destroy
        else
          update_events_search(city_date.date, city_date.city, city_date.state)
        end
      rescue => e
        puts "Something went wrong: #{e}"
    end
  end

  def update_events_search(date, city, state)
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
          if Event.find_by(bandsintown_id:event['id']) != nil
            Event.find_by(bandsintown_id:event['id']).destroy if event['ticket_status'] == 'unavailable'

          elsif event['ticket_status'] == 'available' && Event.find_by(bandsintown_id:event['id']) == nil
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
