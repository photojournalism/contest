require 'rails_helper'

feature 'sign up' do

  let(:user) { FactoryGirl.build(:user) }
  let(:state)   { FactoryGirl.create(:state) }
  let(:country) { FactoryGirl.create(:country)}
  let(:contest) { FactoryGirl.create(:contest) }
  before(:each) { contest.save }

  before(:each) do
    state.save
  end

  scenario 'has countries' do
    visit new_user_registration_path
    expect(page).to have_content(state.country.name)
  end

  scenario 'has states' do
    visit new_user_registration_path
    expect(page).to have_content(state.name)
  end

  scenario 'with valid fields' do
    sign_up(user)
    expect(page).to have_content("Welcome, #{user.first_name}!")
  end

  scenario 'with blank first name' do
    user.first_name = nil
    sign_up(user)
    expect(page).to have_content("First name can't be blank")
  end

  scenario 'with blank last name' do
    user.last_name = nil
    sign_up(user)
    expect(page).to have_content("Last name can't be blank")
  end

  scenario 'with blank street' do
    user.street = nil
    sign_up(user)
    expect(page).to have_content("Street can't be blank")
  end

  scenario 'with blank zip' do
    # Zip is allowed to be blank
    user.zip = nil
    sign_up(user)
    expect(page).to have_content("Welcome, #{user.first_name}!")
  end

  scenario 'with blank day phone' do
    user.day_phone = nil
    sign_up(user)
    expect(page).to have_content("Day phone can't be blank")
  end

  scenario 'with blank evening phone' do
    user.evening_phone = nil
    sign_up(user)
    expect(page).to have_content("Evening phone can't be blank")
  end

  scenario 'with blank email' do
    user.email = nil
    sign_up(user)
    expect(page).to have_content("Email can't be blank")
  end

  scenario 'with blank password' do
    user.password = nil
    sign_up(user)
    expect(page).to have_content("Password can't be blank")
  end

  scenario 'with too short of a password' do
    user.password = "123"
    user.password_confirmation = "123"
    sign_up(user)
    expect(page).to have_content("Password is too short")
  end

  scenario "when passwords don't match" do
    user.password = "password1"
    user.password_confirmation = "password2"
    sign_up(user)
    expect(page).to have_content("Password confirmation doesn't match")
  end

  def sign_up(user)
    visit new_user_registration_path

    fill_in 'First Name', with: user.first_name
    fill_in 'Last Name', with: user.last_name
    fill_in 'Street', with: user.street
    fill_in 'City', with: user.city
    fill_in 'Zip Code', with: user.zip
    fill_in 'Day Phone', with: user.day_phone
    fill_in 'Evening Phone', with: user.evening_phone
    fill_in 'Email Address', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password Confirmation', with: user.password_confirmation
    click_button 'Register'
  end
end