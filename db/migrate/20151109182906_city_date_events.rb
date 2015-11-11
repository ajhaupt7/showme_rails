class CityDateEvents < ActiveRecord::Migration
  def change
    create_table :city_date_events do |t|
      t.integer :city_id
      t.integer :date_id
      t.integer :event_id
    end
  end
end
