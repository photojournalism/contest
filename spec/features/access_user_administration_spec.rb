require 'rails_helper'

feature 'access user administration' do

  before(:all) { User.delete_all }
  let(:user) { FactoryGirl.create(:user) }

  describe 'as not logged in user' do
    scenario 'visit users url' do
      sign_out user
      puts "Admin? #{user.admin}"
      visit users_path
      expect(page).to have_content('Please log in first')
    end

    scenario 'visit users profile' do
      sign_out user
      puts "Admin? #{user.admin}"
      visit user_path(:id => user.id)
      expect(page).to have_content('Please log in first')
    end
  end

  describe 'as non-admin user' do
    before(:each) do
      sign_in(user.email, user.password)
      puts "Admin? #{user.admin}"
    end

    scenario 'visit users url' do
      user.admin = false
      user.save

      visit users_path
      expect(page).to have_content('not authorized')
    end

    scenario 'visit users profile' do
      user.admin = false
      user.save

      visit user_path(:id => user.id)
      expect(page).to have_content('not authorized')
    end
  end

  describe 'as admin user' do
    before(:each) do
      user.admin = true
      user.save

      sign_in(user.email, user.password)
    end

    scenario 'visit users url' do
      visit users_path
      expect(page).to have_content(user.first_name)
    end

    scenario 'visit users profile' do
      visit user_path(:id => user.id)
      expect(page).to have_content(user.first_name)
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