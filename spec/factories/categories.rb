FactoryGirl.define do
  factory :category do
    name "First category"
    description "The first category"
    active true

    association :contest, :factory => :contest
  end
end
