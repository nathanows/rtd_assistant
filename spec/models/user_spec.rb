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

end
