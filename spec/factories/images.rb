FactoryGirl.define do
  factory :image do
    filename "filename.jpg"
    original_filename "original_filename.jpg"
    size 3000
    location "/tmp"

    association :entry, :factory => :entry
  end
end
