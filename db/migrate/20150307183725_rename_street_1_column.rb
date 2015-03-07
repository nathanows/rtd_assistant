class RenameStreet1Column < ActiveRecord::Migration
  def change
    rename_column :locations, :street_1, :street
  end
end
