require 'rails_helper'

RSpec.describe Event, type: :model do
  it { should have_and_belong_to_many :artists }
  it { should belong_to :city_date }
end
