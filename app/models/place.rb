class Place < ActiveRecord::Base
  validates_presence_of :name, :sequence_number
  has_many :entries
end
