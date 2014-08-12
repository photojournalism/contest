require 'rails_helper'

feature 'sign in' do

  let(:user) { FactoryGirl.create(:user) }

  scenario 'visit home path' do
    visit root_path
    expect(page).to have_content('Login')
  end

  scenario 'with valid email and password' do
    sign_in(user.email, user.password)
    expect(page).to have_content('Logout')
  end

  scenario 'with invalid email or password' do
    sign_in('123', '123')
    expect(page).to have_content('Invalid email or password')
  end

  scenario 'with blank email or password' do
    sign_in('', '')
    expect(page).to have_content('Invalid email or password')
  end

  def sign_in(email, password)
    visit new_user_session_path

    fill_in 'Email', with: email
    fill_in 'Password', with: password
    click_button 'Login'
  end
end