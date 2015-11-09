require 'rails_helper'

RSpec.describe Artist, type: :model do
  it { should belong_to :event }
end
