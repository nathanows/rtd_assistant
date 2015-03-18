require 'rails_helper'

RSpec.describe Notification, type: :model do
  it "can route a new completed notification on create" do
    notification = Notification.create(
      user_id: create(:user).id,
      to: create(:location).id,
      from: create(:location).id,
      source: "SMS"
    )

    expect(notification.current_state).to eq("to_pull_directions")
  end
end
