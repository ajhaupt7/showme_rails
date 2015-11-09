class Event < ActiveRecord::Base
  has_many :artists
  belongs_to :city_date
end
