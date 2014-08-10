FactoryGirl.define do
  factory :agreement do
    association :user, :factory => :user
    association :contest, :factory => :contest
  end
end
