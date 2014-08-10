class CategoryType < ActiveRecord::Base
  validates_presence_of :name, :description, :minimum_files, :maximum_files
  validates :active, :inclusion => {:in => [true, false]}
  validates :has_url, :inclusion => {:in => [true, false]}
  has_and_belongs_to_many :categories
  has_and_belongs_to_many :file_types
end
