class CityDate < ActiveRecord::Base
  has_many :events, :dependent => :destroy
end
