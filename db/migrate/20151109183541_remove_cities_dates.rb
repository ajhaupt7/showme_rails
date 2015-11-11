class RemoveCitiesDates < ActiveRecord::Migration
  def change
    drop_table :cities_dates
  end
end
