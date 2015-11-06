class HomeController < ApplicationController
  include Api

  def home
  end

  def spotify
    # Timeout::timeout(15) {
      @events = search_bandsintown(params[:start_date], params[:end_date], params[:city], params[:state])
      respond_to do |format|
        format.json { render json: @events }
      end
    # }
  end

end
