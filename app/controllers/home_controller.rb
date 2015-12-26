class HomeController < ApplicationController
  include Api

  def home
  end

  def about
  end

  def results
    params[:city].strip!
    if params[:city].downcase == "new york city"
      params[:city] = "new york"
    elsif params[:city].downcase == "washington dc" || params[:city].downcase == "washington d.c."
      params[:city] = "washington"
    end
    session[:last_city] = params[:city]
    session[:last_date] = params[:date]
    session[:last_state] = params[:state]
    begin
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
    rescue => e
      flash[:alert] = "Sorry, something went wrong with your request. Try again!"
      puts "Error: #{e}"
      redirect_to root_path
    end
  end

end
