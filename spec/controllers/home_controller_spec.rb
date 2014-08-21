require 'rails_helper'

RSpec.describe HomeController, :type => :controller do
  describe "GET index" do
    let(:contest) { FactoryGirl.create(:contest) }

    it "renders the index template" do
      get :index
      expect(response).to render_template(:index)
    end

    it 'assigns the contest' do
      contest.save
      get :index
      expect(assigns(:contest)).to eq(contest)
    end
  end
end
