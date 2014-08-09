class Category < ActiveRecord::Base
  validates_presence_of :name, :description, :active
  has_and_belongs_to_many :contests
  has_and_belongs_to_many :file_types
end
