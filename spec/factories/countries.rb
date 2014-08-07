require 'faker'

FactoryGirl.define do
  factory :country do |c|
    c.name { Faker::Address.country }
    c.iso { Faker::Address.state_abbr }
  end
end