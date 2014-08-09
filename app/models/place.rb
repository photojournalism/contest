class Place < ActiveRecord::Base
  validates_presence_of :name, :order
  has_many :entries
end
