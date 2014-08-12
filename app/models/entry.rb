class Entry < ActiveRecord::Base
  validates_presence_of :category, :user, :uuid, :contest
  validates :judged, :inclusion => {:in => [true, false]}
  
  belongs_to :category
  belongs_to :user
  belongs_to :place
  belongs_to :contest
  has_many :images
end
