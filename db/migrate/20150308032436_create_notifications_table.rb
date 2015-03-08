class CreateNotificationsTable < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.references :user, index: true
      t.integer :to
      t.integer :from
      t.datetime :send_time
      t.datetime :sent_time
      t.boolean :sent
      t.boolean :to_send
    end
    add_foreign_key :notifications, :users
  end
end
