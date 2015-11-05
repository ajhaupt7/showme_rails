class HomeController < ApplicationController
  include Api

  def home
  end

  def spotify
    @events = search_bandsintown(params[:date], params[:city], params[:state])
  end

end
