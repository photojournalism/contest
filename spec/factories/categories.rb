FactoryGirl.define do
  factory :category do
    name "First category"
    description "The first category"
    active true

    association :category_type, :factory => :category_type
  end
end
