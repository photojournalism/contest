class Contest < ActiveRecord::Base
  validates_presence_of :year, :name, :open_date, :close_date
  validate :close_date_is_after_open_date
  has_and_belongs_to_many :categories

  def close_date_is_after_open_date
    if close_date && open_date
      errors.add(:close_date, "Close date must be after open date") if close_date < open_date
    end
  end
end
