class Image < ActiveRecord::Base
  validates_presence_of :filename, :original_filename, :size, :location, :entry

  belongs_to :entry
end
