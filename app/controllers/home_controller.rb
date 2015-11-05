class HomeController < ApplicationController
  include Api

  def home
  end

  def spotify
    @event = search_bandsintown(params[:date], params[:city], params[:state])
  end

end
