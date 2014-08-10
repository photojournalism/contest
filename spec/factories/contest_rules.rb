# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :contest_rules, :class => 'ContestRules' do
    text "These are some contest rules"
  end
end
