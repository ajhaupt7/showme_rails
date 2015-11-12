task :load_all_cities => :environment do
  biggest_cities_events
end

task :update_events => :environment do
  update_events
end
