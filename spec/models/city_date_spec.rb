require 'rails_helper'

RSpec.describe CityDate, type: :model do
  it { should have_many :events }
end
