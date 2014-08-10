class Category < ActiveRecord::Base
  validates_presence_of :name, :description, :active, :category_type

  belongs_to :category_type
  has_and_belongs_to_many :contests
end
