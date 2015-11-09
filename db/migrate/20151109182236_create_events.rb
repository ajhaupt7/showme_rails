class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.datetime :datetime
      t.string :ticket_url
      t.string :venue_name
      t.float :venue_lat
      t.float :venue_long

      t.timestamps null: false
    end
  end
end
