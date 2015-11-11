class EditCityDateEvents < ActiveRecord::Migration
  def change
    drop_table :city_date_events

    create_table :city_dates_events do |t|
      t.integer :city_date_id
      t.integer :event_id
    end
  end
end
