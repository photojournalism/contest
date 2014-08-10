FactoryGirl.define do
  factory :entry do
    judged false
    url 'https://google.com'
    order_number '12345'

    association :category, :factory => :category
    association :user, :factory => :user
    association :place, :factory => :place
  end
end
