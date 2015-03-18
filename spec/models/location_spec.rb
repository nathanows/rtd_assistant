require 'rails_helper'

RSpec.describe Location, type: :model do

  context 'validations' do
    subject { build(:location) }

    it { should validate_presence_of(:street) }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:state) }
    it { should validate_presence_of(:user_id) }
    it { should belong_to(:user) }
  end

  context 'geocoding' do
    it "should find a location's latitude and longitude" do
      location = create(:location)
      expect(location.lat).to_not be_nil
      expect(location.lng).to_not be_nil
    end
  end

  context 'views' do
    it "should provide a concatenated format of lat and lng" do
      location = create(:location)
      expect(location.lat_lng).to eq("#{location.lat},#{location.lng}")
    end
  end

end
