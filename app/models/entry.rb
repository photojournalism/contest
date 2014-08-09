class Entry < ActiveRecord::Base
  validates_presence_of :category, :user, :judged, :place
end
