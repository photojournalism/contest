# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :entry do
    category FactoryGirl.create(:category)
    user FactoryGirl.create(:user)
    judged false
    place FactoryGirl.create(:place)
  end
end
