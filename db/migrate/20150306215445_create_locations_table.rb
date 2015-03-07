class CreateLocationsTable < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :name
      t.string :street_1
      t.string :street_2
      t.string :city
      t.string :state
      t.integer :zipcode
      t.boolean :active
      t.decimal :lat, {:precision=>10, :scale=>6}
      t.decimal :lng, {:precision=>10, :scale=>6}
      t.boolean :saved_location
    end
  end
end
