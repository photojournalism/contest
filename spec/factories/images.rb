FactoryGirl.define do
  factory :image do
    filename "rails_new.jpg"
    original_filename "original_filename.jpg"
    location 'spec/fixtures/files'
    unique_hash SecureRandom.hex
    caption "This is a caption"
    size 123
    number 1

    association :entry, :factory => :entry
  end
end
