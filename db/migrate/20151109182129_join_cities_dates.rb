class JoinCitiesDates < ActiveRecord::Migration
  def change
    create_table :cities_dates do |t|
      t.integer :city_id
      t.integer :date_id

      t.timestamps
    end
  end
end
