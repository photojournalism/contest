require 'faker'

FactoryGirl.define do
  factory :country do |c|
    c.name 'United States'
    c.iso 'us'
  end
end