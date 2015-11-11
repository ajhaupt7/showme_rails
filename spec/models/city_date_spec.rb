require 'rails_helper'

RSpec.describe CityDate, type: :model do
  it { should have_many :events }
  it 'should destroy associated events upon destruction' do
    city_date = FactoryGirl.create(:city_date)
    event = FactoryGirl.create(:event)
    artist = FactoryGirl.create(:artist)
    event.artists << artist
    city_date.events << event
    city_date.destroy
    Event.all.should eq []
  end
end
