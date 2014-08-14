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
end
