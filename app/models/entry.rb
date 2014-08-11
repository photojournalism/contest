class Entry < ActiveRecord::Base
  validates_presence_of :category, :user, :place, :uuid
  validates :judged, :inclusion => {:in => [true, false]}
  
  belongs_to :category
  belongs_to :user
  belongs_to :place
end
