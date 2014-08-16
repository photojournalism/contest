class RegistrationsController < Devise::RegistrationsController
  
  def new
    get_countries_and_states
    super
  end

  def create
    get_countries_and_states
    super
  end

  private
  
    def get_countries_and_states
      @countries = Country.order('name ASC').all
      @us = Country.where(:name => 'United States').first
      @states = @us ? @us.states : State.where(:country => @countries.first)
      @states = @states.order('name ASC')
    end

    def sign_up_params
      params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :street, :city, :state_id, :zip, :country_id, :day_phone, :evening_phone, :employer)
    end
   
    # def account_update_params
    #   params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :current_password, :street, :city, :state_id, :zip, :country_id, :day_phone, :evening_phone, :employer)
    # end
end