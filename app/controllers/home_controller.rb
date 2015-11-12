class HomeController < ApplicationController
  include Api

  def home
  end

  def about
  end

  def results
    if CityDate.find_by(date: params[:date], city: params[:city], state:params[:state]) == nil
      search_bandsintown(params[:date], params[:city], params[:state])
    end
    @city_date = CityDate.find_by(date: params[:date], city: params[:city], state:params[:state])
    @events = @city_date.events
  end

end
