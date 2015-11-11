class AddCityDateIdToEvents < ActiveRecord::Migration
  def change
    add_column :events, :city_date_id, :integer

    drop_table :city_dates_events

  end
end
