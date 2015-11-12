class HomeController < ApplicationController
  include Api

  def home
  end

  def about
  end

  def results
    if params[:city] == nil
      flash[:alert] = "You must fill out the city field."
      redirect_to root_path
    end
    if CityDate.find_by(date: params[:date], city: params[:city], state:params[:state]) == nil
      search_bandsintown(params[:date], params[:city], params[:state])
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
