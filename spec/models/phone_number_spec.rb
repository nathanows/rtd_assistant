require 'rails_helper'

RSpec.describe PhoneNumber, type: :model do

  context 'validations' do
    it { should validate_presence_of(:number) }
    it { should validate_presence_of(:name) }
    it { should belong_to(:user)  }

    it "should require unique value for number" do
      create(:phone_number, name: "original")
      dup = build(:phone_number, name: "new")
      expect(dup).to_not be_valid
    end

    it "should save the number in a standardized output" do
      phone = create(:phone_number, number: "(999) 888-7777")
      expect(phone.number).to eq("+19998887777")
    end
  end

  context 'views' do
    it "should provide a printable format for phone number" do
      phone = create(:phone_number, number: "(999) 888-7777")
      expect(phone.phone_number).to eq("(999) 888-7777")
    end
  end
end
