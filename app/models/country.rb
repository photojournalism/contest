class Country < ActiveRecord::Base
  validates_presence_of :name, :iso
  has_many :states, dependent: :destroy
end
