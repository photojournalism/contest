require 'fileutils'

class Entry < ActiveRecord::Base
  validates_presence_of :category, :user, :unique_hash, :contest
  validates :judged, :inclusion => {:in => [true, false]}
  
  belongs_to :category
  belongs_to :user
  belongs_to :place
  belongs_to :contest
  has_many :images

  DATE_FORMAT = "%A, %b. %-d, %Y at %-I:%M%P"

  def formatted_created_at
    created_at.strftime(DATE_FORMAT)
  end

  def self.delete_all
    Entry.all.each do |entry|
      FileUtils.rm_rf(entry.images_location)
      entry.destroy!
    end
  end

  def images_location
    "#{Rails.root}/public/images/contest/#{contest.year}/#{category.slug}/#{unique_hash}"
  end
end
