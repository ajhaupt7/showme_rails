scheduler = Rufus::Scheduler.new
include Api

scheduler.every('1d') do
  rufus
end
