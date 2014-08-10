# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :category_type do
    name "Category Type"
    description "Description"
    minimum_files 0
    maximum_files 1
    has_url false
    active true
  end
end
