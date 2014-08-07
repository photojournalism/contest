require 'faker'

FactoryGirl.define do
  factory :user do |f|
    f.first_name { Faker::Name.first_name }
    f.last_name { Faker::Name.last_name }
    f.email { Faker::Internet.email }
    f.street { Faker::Address.street_address }
    f.city { Faker::Address.city }
    f.zip { Faker::Address.zip }
    f.day_phone { Faker::PhoneNumber.phone_number }
    f.evening_phone  { Faker::PhoneNumber.phone_number }
    f.password "password"
    f.password_confirmation "password"

    association :state, :factory => :state
  end
end