class Event < ActiveRecord::Base
  has_many :artists, :dependent => :destroy
  belongs_to :city_date
end
