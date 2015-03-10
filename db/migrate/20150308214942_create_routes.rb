class CreateRoutes < ActiveRecord::Migration
  def change
    create_table :routes do |t|
      t.references :direction_set, index: true
      t.string :walk_to_dep_time
      t.string :walk_to_dep_desc
      t.string :walk_from_arr_time
      t.string :transit_num
      t.string :transit_type
      t.string :transit_dep_time
      t.string :transit_dep_stop
      t.string :transit_arr_time
      t.string :transit_arr_stop
      t.string :departure_time
      t.string :arrival_time
    end
    add_foreign_key :routes, :direction_sets
  end
end
