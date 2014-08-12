require 'rails_helper'

feature 'access places administration' do

  let(:user) { FactoryGirl.create(:user) }
  let(:place) { FactoryGirl.create(:place) }

  describe 'as not logged in user' do
    scenario 'visit places url' do
      sign_out user
      visit places_path
      expect(page).to have_content('Please log in first')
    end
  end

  describe 'as non-admin user' do
    scenario 'visit places url' do
      user.admin = false
      user.save

      sign_in(user.email, user.password)
      visit places_path
      expect(page).to have_content('not authorized')
    end
  end

  describe 'as admin user' do
    before(:each) do
      user.admin = true
      user.save
      
      sign_in(user.email, user.password)
    end

    scenario 'visit places url' do
      place.save
      visit places_path
      expect(page).to have_content(place.name)
    end
  end

  def sign_in(email, password)
    visit new_user_session_path

    fill_in 'Email', with: email
    fill_in 'Password', with: password
    click_button 'Login'
  end

  def sign_out(user)
    sign_in(user.email, user.password)
    click_link 'Logout'
  end
end