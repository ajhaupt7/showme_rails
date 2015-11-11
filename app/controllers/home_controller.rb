class HomeController < ApplicationController
  include Api

  def home
  end

  def about
  end

  def from_database
    @city_date = CityDate.all
  end

  def show
    if CityDate.find_by(date: params[:date], city: params[:city], state:params[:state]) == nil
      search_bandsintown(params[:date], params[:city], params[:state])
    end
    @city_date = CityDate.find_by(date: params[:date], city: params[:city], state:params[:state])
  end

  def save_data
    city_events_month(params[:city], params[:state])
    redirect_to newfeatures_path
  end

  def spotify
    @events = search_bandsintown(params[:date], params[:city], params[:state])
    respond_to do |format|
      format.json { render json: @events }
    end
  end

end
