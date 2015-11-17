class HomeController < ApplicationController
  include Api

  def home
  end

  def about
  end

  def results
    params[:city].strip!.downcase!
    if CityDate.find_by(date: params[:date], city: params[:city], state:params[:state]) == nil
      result = search_bandsintown(params[:date], params[:city], params[:state])
      if result == false
        flash[:alert] = "We either couldn't find that location or there were no events that day. Try again!"
        redirect_to root_path
        return
      end
    end
    @city_date = CityDate.find_by(date: params[:date], city: params[:city], state:params[:state])
    @events = @city_date.events
    @artists = []
    @events.each do |event|
      event.artists.each do |artist|
        @artists.push(artist)
      end
    end
  end

end
