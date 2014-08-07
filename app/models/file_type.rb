class FileType < ActiveRecord::Base
  validates_presence_of :name, :extension
  has_and_belongs_to_many :categories
end
