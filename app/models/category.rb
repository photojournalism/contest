class Category < ActiveRecord::Base
  validates_presence_of :name, :description, :active
  has_many :contests, :through => :contests_categories
  has_many :file_types, :through => :file_types_categories
end
