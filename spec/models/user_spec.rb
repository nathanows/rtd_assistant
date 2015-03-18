require 'rails_helper'

RSpec.describe User, type: :model do

  context 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:password) }
    it { should have_many(:authentications)  }
    it { should have_many(:phone_numbers)  }
    it { should have_many(:locations)  }
    it { should have_many(:notifications)  }
  end

  context 'omniauth' do
    it "can create a user from omniauth" do
      params = {"info" => {
        "email" => "xxxxxx@example.com",
        "last_name" => "smight",
        "first_name" => "sdfsdf",
        "image" => "www.fuckit.com"
      }}
      user = User.create_from_omniauth(params)
      expect(user).to be_a(User)
    end
  end

  context 'helper methods' do
    it "can return an array of the users active location names" do
      user = create(:user)
      user.locations << create(:location, name: "Test")
      user.locations << create(:location, name: "inactive", active: false)
      user.locations << create(:location, name: "saved", saved_location: false)

      expect(user.active_saved_location_names).to eq(["Test"])
    end

    it "can return a users first active phone number" do
      user = create(:user)
      user.phone_numbers << create(:phone_number, number: "(444)444-4444")
      expect(user.phone_number).to eq("+14444444444")
    end
  end
end
