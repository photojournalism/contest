require 'rails_helper'

RSpec.describe PlacesController, :type => :controller do
  render_views
  let(:user) { FactoryGirl.create(:user, :admin => true) }

  describe "GET index" do
    it "assigns @places" do
      sign_in user
      place = FactoryGirl.create(:place)
      get :index
      expect(assigns(:places)).to eq([place])
    end

    it "renders the index template" do
      sign_in user
      get :index
      expect(response).to render_template(:index)
    end

    it "has Administration header" do
      sign_in user
      get :index
      expect(response.body).to match /Administration/
    end

    it "has active Places navigation" do
      sign_in user
      get :index
      expect(response.body).to match '<li class="active"><a href="/admin/places">Places</a></li>'
    end

    it 'redirects to login when not logged in' do
      get :index
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'redirects to root path when not admin' do
      user.admin = false
      user.save

      sign_in user
      get :index
      expect(response).to redirect_to(root_path)
    end
  end
end
