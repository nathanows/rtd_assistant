class UpdateNotificationsTable < ActiveRecord::Migration
  def change
    remove_column :notifications, :to_send
    add_column :notifications, :source, :string
  end
end
