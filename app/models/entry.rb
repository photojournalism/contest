class Entry < ActiveRecord::Base
  validates_presence_of :category, :user, :unique_hash, :contest
  validates :judged, :inclusion => {:in => [true, false]}
  
  belongs_to :category
  belongs_to :user
  belongs_to :place
  belongs_to :contest
  has_many :images

  DATE_FORMAT = "%A, %b. %-d, %Y at %-I:%M%P %Z"

  def formatted_created_at
    created_at.strftime(DATE_FORMAT)
  end

  def self.delete_all
    Entry.all.each do |entry|
      entry.delete
    end
  end

  def delete
    images.each do |image|
      image.delete
    end
    
    FileUtils.rm_rf(images_location)
    destroy!
  end

  def edit_url
    "/entries/#{unique_hash}"
  end

  def confirmation_url
    "/entries/#{unique_hash}/confirmation"
  end

  def images_location
    "#{Rails.root}/public/images/contest/#{contest.year}/#{category.slug}/#{unique_hash}"
  end
end
