require 'faker'

FactoryGirl.define do
  factory :state do |s|
    s.name { Faker::Address.state }
    s.iso { Faker::Address.state_abbr }
    s.country_id FactoryGirl.create(:country).id
  end
end