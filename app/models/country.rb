class Country < ActiveRecord::Base
  has_many :states, dependent: :destroy
end
