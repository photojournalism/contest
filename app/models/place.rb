class Place < ActiveRecord::Base
  validates_presence_of :name, :sequence_number
  validates_uniqueness_of :sequence_number
  has_many :entries
end
