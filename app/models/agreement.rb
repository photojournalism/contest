class Agreement < ActiveRecord::Base
  validates_presence_of :user, :contest
  belongs_to :user
  belongs_to :contest
end
