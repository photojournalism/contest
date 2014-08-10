require 'rails_helper'

RSpec.describe EntriesController, :type => :controller do
  render_views

  describe "GET new" do
    before(:all) { FactoryGirl.create(:contest) }
    let(:user) { FactoryGirl.create(:user) }
    let(:contest) { Contest.current }
    let(:category) { FactoryGirl.create(:category) }

    it 'should redirect to login page when not logged in' do
      get :new
      expect(response).to redirect_to(new_user_session_path)
    end

    it "should display notification when contest hasn't started" do
      sign_in user
      set_contest_dates(1.day.from_now, 3.days.from_now)
      get :new
      expect(response.body).to match 'will open on'
    end

    it 'should display notification when contest has ended' do
      sign_in user
      set_contest_dates(3.days.ago, 1.day.ago)
      get :new
      expect(response.body).to match 'ended'
    end

    it 'assigns @categories when contest is open and an agreement for user exists' do
      sign_in user
      set_contest_dates(3.days.ago, 1.day.from_now)
      category.save
      contest.categories << category
      agreement = Agreement.create(:contest => contest, :user => user)

      get :new
      expect(assigns(:categories)).to eq([category])
    end

    it 'renders new template when contest is open and an agreement for user exists' do
      sign_in user
      set_contest_dates(3.days.ago, 1.day.from_now)
      category.save
      contest.categories << category
      agreement = Agreement.create(:contest => contest, :user => user)

      get :new
      expect(response).to render_template(:new)
    end

    it "redirects to new agreement when one doesn't exist" do
      sign_in user
      set_contest_dates(3.days.ago, 1.day.from_now)
      get :new
      expect(response).to redirect_to(new_agreement_path)
    end

    def set_contest_dates(open_date, close_date)
      contest.open_date = open_date
      contest.close_date = close_date
      contest.save
    end
  end
end
