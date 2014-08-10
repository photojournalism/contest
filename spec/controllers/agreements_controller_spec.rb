require 'rails_helper'

RSpec.describe AgreementsController, :type => :controller do
  describe "GET new" do
    before(:all) { FactoryGirl.create(:contest) }
    let(:contest) { Contest.current }

    before(:each) do
      controller.class.skip_before_action :authenticate_user!
      contest.save
    end

    it 'assigns @contest' do
      get :new
      expect(assigns(:contest)).to eq(contest)
    end

    it 'assigns @rules' do
      get :new
      expect(assigns(:rules)).to eq(contest.contest_rules.text.html_safe)
    end

    it 'renders the new template' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'POST create' do
    let(:user) {FactoryGirl.create(:user) }

    it 'creates a new agreement' do
      agreement = FactoryGirl.build(:agreement)
      Agreement.stub(:new) { agreement }
      
      sign_in user
      post :create
      expect(Agreement.count).to eq(1)
    end

    it 'redirects to new_entry_path' do
      sign_in user
      post :create
      expect(response).to redirect_to(new_entry_path)
    end
  end
end
