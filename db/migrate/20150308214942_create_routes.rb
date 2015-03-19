class CreateRoutes < ActiveRecord::Migration
  def change
    create_table :routes do |t|
      t.references :direction_set, index: true
      t.integer :option
      t.string :start_address
      t.string :end_address
      t.time :departure_time
      t.time :arrival_time
      t.string :distance
      t.string :duration
    end
    add_foreign_key :routes, :direction_sets
  end
end
