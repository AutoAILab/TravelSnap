FactoryGirl.define do
  factory :follow_relation do
    user
    association :follower, factory: :user
    status :pending
  end
end
