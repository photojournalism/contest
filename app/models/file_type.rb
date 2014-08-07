class FileType < ActiveRecord::Base
  validates_presence_of :name, :extension
  has_many :categories, :through => :file_types_categories
end
