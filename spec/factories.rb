FactoryGirl.define do
  factory :city_date do
    city 'portland'
    state 'OR'
    date "2015-11-20"
  end

  factory :event do
    venue_name 'Mississippi Studios'
    ticket_url "http://www.bandsintown.com/event/10415291/buy_tickets?came_from=233"
    datetime 'Thu, 05 Nov 2015 18:00:00 UTC +00:00'
  end

  factory :artist do
    name 'Borns'
    song_preview "https://p.scdn.co/mp3-preview/35fd0d25f3d4d9738c9119adb9bd0090aaaf79ba"
    image_url "https://i.scdn.co/image/b6aa340e1b3e23f06e02a415d13d5992de0765da"
  end
end
