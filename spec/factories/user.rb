FactoryGirl.define do
  sequence :email do |n|
    "email#{n}@example.com"
  end

  factory :user do
    email { generate :email }
    password '12345'
  end
end
