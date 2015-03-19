class CreateSteps < ActiveRecord::Migration
  def change
    create_table :steps do |t|
      t.references :route, index: true
      t.string :distance
      t.string :duration
      t.text   :instructions
      t.string :travel_mode
      t.string :arrival_stop
      t.time :arrival_time
      t.string :departure_stop
      t.time :departure_time
      t.string :headsign
      t.string :trans_name
      t.string :trans_short_name
      t.string :trans_type
      t.integer :trans_stops
      t.timestamps null: false
    end
    add_foreign_key :steps, :routes
  end
end
