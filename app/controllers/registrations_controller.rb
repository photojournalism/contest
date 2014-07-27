class RegistrationsController < Devise::RegistrationsController
  
  def new
    @countries = Country.order('name ASC').all
    super
  end

  def create
    @countries = Country.order('name ASC').all
    super
  end

  private
 
  def sign_up_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :street, :city, :state_id, :zip, :country_id, :day_phone, :evening_phone, :employer)
  end
 
  def account_update_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :current_password, :street, :city, :state_id, :zip, :country_id, :day_phone, :evening_phone, :employer)
  end
end