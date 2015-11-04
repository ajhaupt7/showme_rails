require 'rspotify'

module Api

  def return_similar(artist)
    results = []
    results.push(get_more(artist))
    random_num = Random.rand(results[0].length - 1)
    results.push(search_spotify(artist))
    results.flatten!
    until results.length > 40 do
      results.push(get_more(results[random_num].name))
    end
    results.flatten!
    return results.uniq { |result| result.name }
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

  # def search_spotify(query)
  #   artists = RSpotify::Artist.search(query)
  #   found_artist = artists.first
  #   albums = found_artist.albums
  #   returned = []
  #   albums.each do |album|
  #     if album.name.include?("Deluxe") || album.name.include?("Remix") || album.name.include?("Acoustic") || album.name.include?("Live") || album.name.include?("Remastered") || album.name.include?("International") || album.name.include?("Version") || album.name.include?("Greatest Hits")
  #       puts album.name
  #     else
  #       returned.push(album)
  #     end
  #   end
  #
  #   return returned
  # end


  def search_songkick

  end

end
