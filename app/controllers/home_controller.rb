class HomeController < ApplicationController
  include Api

  def home
  end

  def spotify
    year = params[:dateYear]
    month = params[:dateMonth]
    day = params[:dateDay]
    if day.to_i < 10
      day = '0' + day.to_s
    end
    params[:date] = "#{year}-#{month}-#{day}"
    @events = search_bandsintown(params[:date], params[:city], params[:state])
    respond_to do |format|
      format.json { render json: @events }
    end
  end

end
