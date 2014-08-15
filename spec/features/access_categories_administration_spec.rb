require 'rails_helper'

feature 'access categories administration' do

  let(:category) { FactoryGirl.create(:category) }
  let(:user) { FactoryGirl.create(:user) }


  describe 'as not logged in user' do
    scenario 'visit categories url' do
      visit categories_path
      expect(page).to have_content('Please log in first')
    end
  end

  describe 'as non-admin user' do
    scenario 'visit categories url' do
      sign_in(user.email, user.password)
      visit categories_path
      expect(page).to have_content('not authorized')
    end
  end

  describe 'as admin user' do
    before(:each) do
      user.admin = true
      user.save

      sign_in(user.email, user.password)
    end

    scenario 'visit categories url' do
      category.save
      visit categories_path
      expect(page).to have_content(category.name)
    end
  end

  def sign_in(email, password)
    visit new_user_session_path

    fill_in 'Email', with: email
    fill_in 'Password', with: password
    click_button 'Login'
  end
end