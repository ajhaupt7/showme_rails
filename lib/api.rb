require 'rspotify'
require 'rest_client'


module Api
  def search_spotify(query)
    puts "Query: #{query}"
    result = nil
    begin
      artists = RSpotify::Artist.search(query)
      found_artist = artists.first
      if found_artist.popularity < 50
        result = found_artist
        puts "#{result} in the loop"
      end
    rescue => e
      puts "Caught #{e}"
    end
    puts "#{result} at the end"
    return result
  end


  def search_bandsintown(start_date, end_date, city, state)
    found_events = []

    begin
      base_url = "http://api.bandsintown.com/events/search.json?api_version=2.0&app_id=#{ENV['BANDSINTOWN_ID']}&date=#{start_date},#{end_date}&location=#{city},#{state}"
      unclean = RestClient.get(base_url)
      events = JSON.parse(unclean)

      found_artist = nil

      events.each do |event|
        puts "here"
        spotify_search_result = search_spotify(event['artists'][0]['name'])
        if spotify_search_result != nil && event['ticket_status'] == 'available'
          found_events.push(event)
        end
      end
    rescue => e
      puts "Something went terribly wrong :( #{e}"
      return false
    end
    return found_events
  end
end




























#
