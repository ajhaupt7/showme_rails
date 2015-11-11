class HomeController < ApplicationController
  include Api

  def home
  end

  def about
  end

  def from_database
    @city_date = CityDate.all
  end

  def results
    binding.pry
    if CityDate.find_by(date: params[:date], city: params[:city], state:params[:state]) == nil
      search_bandsintown(params[:date], params[:city], params[:state])
    end
    @city_date = CityDate.find_by(date: params[:date], city: params[:city], state:params[:state])
    @events = @city_date.events
  end

  def save_data
    city_events_month(params[:city], params[:state])
    redirect_to newfeatures_path
  end

end
