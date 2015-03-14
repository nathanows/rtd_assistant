require 'rails_helper'

describe NotificationsHelper do
  context "notification creation" do
    before do
      Notification.skip_callback(:create, :after, :send_text_message)

      @user = create(:user)
      create(:location, name: "home", user_id: @user.id)
      create(:location, name: "school", street: "1510 Blake St",
             city: "Denver", state: "CO", user_id: @user.id)
    end

    xit "can create a new notification from a text string" do
      create_notification("home school", @user)
      expect(@user.notifications.count).to eq(1)
    end

    after do
      Notification.set_callback(:create, :after, :send_text_message)
    end
  end

  context "text message validity" do
    before do
      @user = create(:user)
      create(:location, name: "home", user_id: @user.id)
      create(:location, name: "school", street: "1510 Blake St",
             city: "Denver", state: "CO", user_id: @user.id)
    end

    it "is invalid without a user" do
      user = nil
      message = "test message"
      response = valid_message?(message, user)
      expect(response[0]).to be_falsey
      expect(response[1]).to include("Hmm... We're not finding this number")
    end

    it "is invalid if more than two words" do
      message = "test message too long"
      response = valid_message?(message, @user)
      expect(response[0]).to be_falsey
      expect(response[1]).to include("Whoopsie... that doesn't seem")
    end

    it "is invalid if the from location doesn't exist" do
      message = "zimbabwe home"
      response = valid_message?(message, @user)
      expect(response[0]).to be_falsey
      expect(response[1]).to include("Sorry... zimbabwe doesn't")
    end

    it "is invalid if the from location doesn't exist" do
      message = "school jupiter"
      response = valid_message?(message, @user)
      expect(response[0]).to be_falsey
      expect(response[1]).to include("Sorry... jupiter doesn't")
    end

    it "is valid with a correct message" do
      message = "school home"
      response = valid_message?(message, @user)
      expect(response[0]).to be_truthy
    end
  end
end
