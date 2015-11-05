class HomeController < ApplicationController
  include Api

  def home
  end

  def spotify
    @events = search_bandsintown(params[:artist], params[:city], params[:state])

  end

end
