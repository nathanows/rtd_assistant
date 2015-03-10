class CreateDirectionSets < ActiveRecord::Migration
  def change
    create_table :direction_sets do |t|
      t.references :notification, index: true

      t.timestamps null: false
    end
    add_foreign_key :direction_sets, :notifications
  end
end
