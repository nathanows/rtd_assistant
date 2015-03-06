class CreatePhoneNumbersTable < ActiveRecord::Migration
  def change
    create_table :phone_numbers do |t|
      t.string :number
      t.boolean :active
      t.boolean :verified
      t.datetime :verified_at
    end
  end
end
