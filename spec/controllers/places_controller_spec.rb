require 'rails_helper'

RSpec.describe PlacesController, :type => :controller do
  render_views
  describe "GET index" do
    before(:each) { controller.class.skip_before_filter :require_admin }

    it "assigns @places" do
      place = FactoryGirl.create(:place)
      get :index
      expect(assigns(:places)).to eq([place])
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template(:index)
    end

    it "has Administration header" do
      get :index
      expect(response.body).to match /Administration/
    end

    it "has active Places navigation" do
      get :index
      expect(response.body).to match '<li class="active"><a href="/admin/places">Places</a></li>'
    end
  end
end
