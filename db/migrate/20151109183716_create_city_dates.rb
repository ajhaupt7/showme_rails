class CreateCityDates < ActiveRecord::Migration
  def change
    create_table :city_dates do |t|
      t.string :city
      t.string :state
      t.date :date

      t.timestamps null: false
    end
  end
end
