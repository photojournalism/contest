class ContestRules < ActiveRecord::Base
  validates_presence_of :text
  has_many :contests
end
