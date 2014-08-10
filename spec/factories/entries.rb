FactoryGirl.define do
  factory :entry do
    judged false

    association :category, :factory => :category
    association :user, :factory => :user
    association :place, :factory => :place
  end
end
