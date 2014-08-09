class Contest < ActiveRecord::Base
  validates_presence_of :year, :name, :open_date, :close_date
  validate :close_date_is_after_open_date
  has_and_belongs_to_many :categories

  def close_date_is_after_open_date
    if close_date && open_date
      errors.add(:close_date, "Close date must be after open date") if close_date < open_date
    end
  end

  def is_open?
    now = Date.new
    if open_date < now && close_date > now
      return true
    end
    return false
  end

  def has_started?
    now = Date.new
    if open_date < now
      return true
    end
    return false
  end

  def has_ended?
    now = Date.new
    if close_date < now
      return true
    end
    return false
  end

  def formatted_open_date
    open_date.strftime("%A, %b. %-d, %Y at %-I:%M%P")
  end

  def formatted_close_date
    close_date.strftime("%A, %b. %-d, %Y at %-I:%M%P")
  end

  def self.current
    Contest.all.order('year DESC').first
  end

  def to_s
    "#{year} #{name}"
  end
end
