class Event < ActiveRecord::Base
  has_and_belongs_to_many :artists
  belongs_to :city_date

  def gmaps_venue
    self.venue_name.split(" ").join("+")
  end
end
