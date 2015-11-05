class HomeController < ApplicationController
  include Api

  def home
  end

  def spotify
    @events = return_similar(params[:artist], params[:city], params[:state])
    @events.reject! { |event| event.empty? }
  end

end
