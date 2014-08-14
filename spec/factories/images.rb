FactoryGirl.define do
  factory :image do
    filename "filename.jpg"
    original_filename "original_filename.jpg"
    size 3000
    location "/tmp"
    unique_hash SecureRandom.hex
    caption "This is a caption"
    number 1

    association :entry, :factory => :entry
  end
end
