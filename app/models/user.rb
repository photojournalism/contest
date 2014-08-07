require 'biggs'

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates_presence_of :email, :first_name, :last_name, :street, :city, :state_id, :country_id, :day_phone, :evening_phone

  def full_name
    "#{first_name} #{last_name}"
  end

  def address
    country = Country.find(country_id)
    state   = State.find(state_id)
    
    f = Biggs::Formatter.new
    f.format(country.iso.downcase,
      :street     => street,
      :city       => city,
      :zip        => zip,
      :state      => state.name
    )
  end
end
