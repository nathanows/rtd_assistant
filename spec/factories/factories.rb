FactoryGirl.define do
  sequence :email do |n|
    "person#{n}@example.com"
  end

  factory :phone_number do
    number "(999) 999-9999"
    name "TestNumber"
    active true
  end

  factory :user do
    email
    first_name "Nathan"
    last_name "Caution"
    password "password"
  end

  factory :location do
    name "Home"
    street "210 E 2nd Ave"
    city "New York"
    state "NY"
    zipcode "10003"
    active true
    saved_location true
    association :user
  end
end
