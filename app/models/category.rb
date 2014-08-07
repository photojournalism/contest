class Category < ActiveRecord::Base
  validates_presence_of :name, :description, :active
  belongs_to :contest
  has_and_belongs_to_many :filetypes
end
