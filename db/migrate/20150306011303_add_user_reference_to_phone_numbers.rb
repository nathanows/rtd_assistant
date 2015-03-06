class AddUserReferenceToPhoneNumbers < ActiveRecord::Migration
  def change
    add_reference :phone_numbers, :user, index: true
    add_foreign_key :phone_numbers, :users
  end
end
