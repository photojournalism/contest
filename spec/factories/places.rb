FactoryGirl.define do
  factory :place do
    name "First Place"
    sequence(:sequence_number) { |n| n }
  end
end
