class Contest < ActiveRecord::Base
  validates_presence_of :year, :name, :open_date, :close_date, :contest_rules
  validate :close_date_is_after_open_date
  has_and_belongs_to_many :categories
  belongs_to :contest_rules
  has_many :agreements
  has_many :entries

  DATE_FORMAT = "%A, %b. %-d, %Y at %-I:%M%P"

  def close_date_is_after_open_date
    if close_date && open_date
      errors.add(:close_date, "Close date must be after open date") if close_date < open_date
    end
  end

  def is_open?
    now = Time.now
    open_date < now && close_date > now
  end

  def has_started?
    now = Time.now
    open_date < now
  end

  def has_ended?
    now = Time.now
    close_date < now
  end

  def has_agreement_for?(user)
    agreement = Agreement.where(:user => user, :contest => self).first
    return (agreement ? true : false)
  end

  def formatted_open_date
    open_date.strftime(DATE_FORMAT)
  end

  def formatted_close_date
    close_date.strftime(DATE_FORMAT)
  end

  def winning_entries
    entries_count = 0
    entries.each do |entry|
      if entry.place && entry.place.sequence_number.to_i != 99
        entries_count += 1
      end
    end
    entries_count
  end

  def self.current
    Contest.all.order('year DESC').first
  end

  def to_s
    "#{year} #{name}"
  end
end
