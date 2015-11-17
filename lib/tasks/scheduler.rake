desc 'loads event data for 30 biggest cities for the next month'
task :load_all_cities => :environment do
  biggest_cities_events
end

desc 'updates previously existing events, deletes events that have occurred'
task :update_events => :environment do
  update_events
end

desc 'destroys artists who have no upcoming concerts'
task :clean_artists_database => :environment do
  clean_artists_database
end
