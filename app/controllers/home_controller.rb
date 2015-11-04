class HomeController < ApplicationController
  include Api

  def home
  end

  def spotify
    @result = return_similar(params[:query])
  end

end
