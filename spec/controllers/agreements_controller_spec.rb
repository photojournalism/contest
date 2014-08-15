require 'rails_helper'

RSpec.describe AgreementsController, :type => :controller do
  before(:all) { FactoryGirl.create(:contest) }
  after(:all) { contest.destroy! }
  
  let(:user) { FactoryGirl.create(:user) }

  describe "GET new" do
    let(:contest) { Contest.current }

    before(:each) do
      contest.save
    end

    it 'assigns @contest' do
      sign_in user
      get :new
      expect(assigns(:contest)).to eq(contest)
    end

    it 'assigns @rules' do
      sign_in user
      get :new
      expect(assigns(:rules)).to eq(contest.contest_rules.text.html_safe)
    end

    it 'renders the new template' do
      sign_in user
      get :new
      expect(response).to render_template(:new)
    end

    it 'redirects to login path when not logged in' do
      get :new
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe 'POST create' do
    let(:contest) { Contest.current }

    it 'assigns @contest' do
      sign_in user
      post :create
      expect(assigns(:contest)).to eq(contest)
    end

    it 'creates a new agreement' do
      sign_in user
      expect {
        post :create
      }.to change(Agreement, :count).by(1)
    end

    it 'redirects to new_entry_path' do
      sign_in user
      post :create
      expect(response).to redirect_to(new_entry_path)
    end

    it 'redirects to login path when not logged in' do
      post :create
      expect(response).to redirect_to(new_user_session_path)
    end
  end
end
