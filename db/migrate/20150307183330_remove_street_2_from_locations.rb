class RemoveStreet2FromLocations < ActiveRecord::Migration
  def change
    remove_column :locations, :street_2
  end
end
