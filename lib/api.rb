require 'rspotify'
require 'rest_client'


module Api

  # def return_similar(artist, city, state)
  #   upcoming_events = []
  #   results = []
  #   results.push(get_more(artist))
  #   random_num = Random.rand(results[0].length - 1)
  #   results.push(search_spotify(artist))
  #   results.flatten!
  #   until results.length > 40 do
  #     results.push(get_more(results[random_num].name))
  #   end
  #   results.flatten!
  #   concert_artists = results.uniq { |result| result.name }
  #
  #   concert_artists.each do |artist|
  #     concert = search_bandsintown(artist.name, city, state)
  #     if concert != nil
  #       upcoming_events.push(search_bandsintown(artist.name, city, state))
  #     end
  #   end
  #
  #   return upcoming_events
  # end
  #
  #
  # def search_spotify(query)
  #   artists = RSpotify::Artist.search(query)
  #   found_artist = artists.first
  #   related_artists = found_artist.related_artists
  #   least_popular = nil
  #
  #   related_artists.each do |related_artist|
  #     if least_popular == nil
  #       least_popular = related_artist
  #     elsif related_artist.popularity < least_popular.popularity
  #       least_popular = related_artist
  #     end
  #   end
  #
  #   if least_popular.popularity > 10
  #     search_spotify(least_popular.name)
  #   else
  #     return related_artists
  #   end
  # end
  #
  # def get_more(query)
  #   artists = RSpotify::Artist.search(query)
  #   found_artist = artists.first
  #   related_artists = found_artist.related_artists
  # end
  #
  # def search_bandsintown(artist, city, state)
  #   artist = artist.tr(
  #   "ÀÁÂÃÄÅàáâãäåĀāĂăĄąÇçĆćĈĉĊċČčÐðĎďĐđÈÉÊËèéêëĒēĔĕĖėĘęĚěĜĝĞğĠġĢģĤĥĦħÌÍÎÏìíîïĨĩĪīĬĭĮįİıĴĵĶķĸĹĺĻļĽľĿŀŁłÑñŃńŅņŇňŉŊŋÒÓÔÕÖØòóôõöøŌōŎŏŐőŔŕŖŗŘřŚśŜŝŞşŠšſŢţŤťŦŧÙÚÛÜùúûüŨũŪūŬŭŮůŰűŲųŴŵÝýÿŶŷŸŹźŻżŽž",
  #   "AAAAAAaaaaaaAaAaAaCcCcCcCcCcDdDdDdEEEEeeeeEeEeEeEeEeGgGgGgGgHhHhIIIIiiiiIiIiIiIiIiJjKkkLlLlLlLlLlNnNnNnNnnNnOOOOOOooooooOoOoOoRrRrRrSsSsSsSssTtTtTtUUUUuuuuUuUuUuUuUuUuWwYyyYyYZzZzZz")
  #   begin
  #     base_url = "http://api.bandsintown.com/events/search?artists[]=#{artist}&location=#{city},#{state}&radius=25&format=json&app_id=#{ENV['BANDSINTOWN_ID']}"
  #     unclean = RestClient.get(base_url)
  #     events = JSON.parse(unclean)
  #     puts "#{artist} - #{events}"
  #     return events
  #   rescue RestClient::ResourceNotFound => e
  #     puts "No events for #{artist}"
  #   rescue URI::InvalidURIError => e
  #     puts "Artist name no English #{artist}"
  #   rescue RestClient::BadRequest => e
  #     puts "Bad request #{e}"
  #   rescue => e
  #     puts "Something went terribly wrong :( #{e}"
  #   end
  #   return events if events
  # end

  def search_spotify(query)
    puts "Query: #{query}"
    result = nil
    begin
      artists = RSpotify::Artist.search(query)
      found_artist = artists.first
      if found_artist.popularity < 35
        result = found_artist
        puts "#{result} in the loop"
      end
    rescue => e
      puts "Caught #{e}"
    end
    puts "#{result} at the end"
    return result
  end


  def search_bandsintown(date, city, state)
    year = date['year']
    month = date['month']
    day = date['day']
    if day.to_i < 10
      day = '0' + day.to_s
    end

    date = "#{year}-#{month}-#{day}"
    found_event = nil

    begin
      base_url = "http://api.bandsintown.com/events/search.json?api_version=2.0&app_id=#{ENV['BANDSINTOWN_ID']}&date=#{date}&location=#{city},#{state}"
      unclean = RestClient.get(base_url)
      events = JSON.parse(unclean)

      found_artist = nil

      events.each do |event|
        spotify_search_result = search_spotify(event['artists'][0]['name'])
        if spotify_search_result != nil
          found_event = event
        end
        if found_event
          return found_event
        end
      end
    # rescue RestClient::ResourceNotFround => e
    #   puts "No events for #{date}"
    #   return false
    # rescue URI::InvalidURIError => e
    #   puts "Artist name no English #{date}"
    #   return false
    # rescue RestClient::BadRequest => e
    #   puts "Bad request #{e}"
    #   return false
    rescue => e
      puts "Something went terribly wrong :( #{e}"
      return false
    end
    return found_event
  end
end




























#
