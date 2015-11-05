require 'rspotify'
require 'rest_client'


module Api

  def return_similar(artist, city, state)
    upcoming_events = []
    results = []
    results.push(get_more(artist))
    random_num = Random.rand(results[0].length - 1)
    results.push(search_spotify(artist))
    results.flatten!
    until results.length > 40 do
      results.push(get_more(results[random_num].name))
    end
    results.flatten!
    concert_artists = results.uniq { |result| result.name }

    concert_artists.each do |artist|
      concert = search_bandsintown(artist.name, city, state)
      if concert != nil
        upcoming_events.push(search_bandsintown(artist.name, city, state))
      end
    end

    return upcoming_events
  end


  def search_spotify(query)
    artists = RSpotify::Artist.search(query)
    found_artist = artists.first
    related_artists = found_artist.related_artists
    least_popular = nil

    related_artists.each do |related_artist|
      if least_popular == nil
        least_popular = related_artist
      elsif related_artist.popularity < least_popular.popularity
        least_popular = related_artist
      end
    end

    if least_popular.popularity > 10
      search_spotify(least_popular.name)
    else
      return related_artists
    end
  end

  def get_more(query)
    artists = RSpotify::Artist.search(query)
    found_artist = artists.first
    related_artists = found_artist.related_artists
  end

  def search_bandsintown(artist, city, state)
    artist = artist.tr(
    "ÀÁÂÃÄÅàáâãäåĀāĂăĄąÇçĆćĈĉĊċČčÐðĎďĐđÈÉÊËèéêëĒēĔĕĖėĘęĚěĜĝĞğĠġĢģĤĥĦħÌÍÎÏìíîïĨĩĪīĬĭĮįİıĴĵĶķĸĹĺĻļĽľĿŀŁłÑñŃńŅņŇňŉŊŋÒÓÔÕÖØòóôõöøŌōŎŏŐőŔŕŖŗŘřŚśŜŝŞşŠšſŢţŤťŦŧÙÚÛÜùúûüŨũŪūŬŭŮůŰűŲųŴŵÝýÿŶŷŸŹźŻżŽž",
    "AAAAAAaaaaaaAaAaAaCcCcCcCcCcDdDdDdEEEEeeeeEeEeEeEeEeGgGgGgGgHhHhIIIIiiiiIiIiIiIiIiJjKkkLlLlLlLlLlNnNnNnNnnNnOOOOOOooooooOoOoOoRrRrRrSsSsSsSssTtTtTtUUUUuuuuUuUuUuUuUuUuWwYyyYyYZzZzZz")
    begin
      base_url = "http://api.bandsintown.com/events/search?artists[]=#{artist}&location=#{city},#{state}&radius=25&format=json&app_id=#{ENV['BANDSINTOWN_ID']}"
      unclean = RestClient.get(base_url)
      events = JSON.parse(unclean)
      puts "#{artist} - #{events}"
      return events
    rescue RestClient::ResourceNotFound => e
      puts "No events for #{artist}"
    rescue URI::InvalidURIError => e
      puts "Artist name no English #{artist}"
    rescue RestClient::BadRequest => e
      puts "Bad request #{e}"
    rescue => e
      puts "Something went terribly wrong :( #{e}"
    end
    return events if events
  end

end




























#
