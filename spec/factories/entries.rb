# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :entry do
    judged false

    association :category, :factory => :category
    association :user, :factory => :user
    association :place, :factory => :place
  end
end
