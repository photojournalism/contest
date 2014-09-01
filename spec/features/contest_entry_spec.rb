require 'rails_helper'

feature 'contest entry' do

  let(:user) { FactoryGirl.create(:user) }
  let(:contest) { FactoryGirl.create(:contest) }
  let(:category1) { FactoryGirl.create(:category) }
  let(:category2) { FactoryGirl.create(:category) }
  before(:each) do
    contest.categories << category1
    contest.categories << category2
    contest.save
  end

  describe 'when contest is open', :js => true do
    before(:each) do
      sign_in user

      contest.open_date = 1.year.ago
      contest.close_date = 1.year.from_now
      contest.save
    end

    describe 'before an agreement has been made' do
      describe 'when visiting the entry page' do
        it 'should show agreement page' do
          visit new_entry_path
          expect(page).to have_content('you must agree to the rules of the contest')
        end
      end
    end

    describe 'after an agreement has been made' do
      before(:each) do
        agreement = FactoryGirl.create(:agreement, :user => user, :contest => Contest.current)
        agreement.save
      end

      describe 'when visiting the entry page' do
        it 'should show contest entry page' do
          visit new_entry_path
          expect(page).to have_content('Submit New Contest Entry')
          expect(page).to have_content(category1.name)
          expect(page).to have_content(category1.description)
        end
      end

      describe 'when creating an entry' do        
        it 'should show the contest edit page' do
          visit new_entry_path
          fill_in 'entry-order-number', :with => '123'
          click_button 'entry-continue-button'
          expect(page).to have_content(category1.name)
          expect(page).to have_content(category1.category_type.description)
          expect(page).to have_content('Delete Entry')
        end
      end

      describe 'when saving an entry' do
        it 'should display the confirmation page' do
          visit new_entry_path
          fill_in 'entry-order-number', :with => '123'
          click_button 'entry-continue-button'
          fill_in 'entry-url', :with => 'http://google.com'
          click_button 'entry-save-button'
          expect(page).to have_content('Confirmation')
          expect(page).to have_content('Delete Entry')
          expect(page).to have_content('Edit Entry')
        end
      end
    end
  end

  def sign_in(user)
    visit new_user_session_path

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Login'
  end
end