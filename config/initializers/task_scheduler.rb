scheduler = Rufus::Scheduler.new

include Api

scheduler.every('1d') do
  city_events_month("portland", "OR")
end
