class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates_presence_of :email, :first_name, :last_name, :street, :city, :state_id, :day_phone, :evening_phone
  belongs_to :state
  has_many :agreements
  has_many :entries
  has_one :country, :through => :state

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

  def name
    full_name
  end

  def to_s
    full_name
  end
end
