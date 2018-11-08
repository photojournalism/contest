class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates_presence_of :first_name, :last_name
  belongs_to :state
  belongs_to :user
  has_many :agreements
  has_many :entries
  has_many :users
  has_one :country, :through => :state

  before_save do |user|
    user.first_name.strip!
    user.last_name.strip!

    user.first_name.capitalize!
    user.last_name.capitalize!
  end

  def affiliation
    if employer && employer != ''
      return employer
    elsif school && school != ''
      return school
    end
    return nil
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def address
    f = Biggs::Formatter.new
    f.format(country.iso.downcase,
      :street     => street,
      :city       => city,
      :zip        => zip,
      :state      => state.name
    )
  end

  def completed_entries
    Entry.where(:user => self, :pending => false, :contest => Contest.current)
  end

  def pending_entries
    Entry.where(:user => self, :pending => true, :contest => Contest.current)
  end

  def current_entries
    Entry.where(:user => self, :contest => Contest.current)
  end

  def managed_entries
    entries = []
    self.users.each do |user|
      user_entries = Entry.where(:user => user, :contest => Contest.current)
      user_entries.each do |entry|
        entries << entry
      end
    end
    entries
  end

  def name
    full_name
  end

  def to_s
    full_name
  end

  def current_order_number
    entries = current_entries.select { |e| e.order_number && e.order_number != '' }
    if entries.size > 0
      return entries[0].order_number
    end
    return ''
  end
end
