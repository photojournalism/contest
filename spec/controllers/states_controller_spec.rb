require 'rails_helper'

RSpec.describe StatesController, :type => :controller do
  render_views

  describe "GET get_select_for_country" do
    let(:state) { FactoryGirl.create(:state) }

    it "assigns @states" do
      get :get_select_for_country, :country_id => state.country.id
      expect(assigns(:states)).to eq([state])
    end

    it "renders the get_select_for_country template" do
      get :get_select_for_country, :country_id => state.country.id
      expect(response).to render_template(:get_select_for_country)
    end

    it "displays an option list" do
      get :get_select_for_country, :country_id => state.country.id
      expect(response.body).to match 'option'
    end

    it "has the state in the option list" do
      get :get_select_for_country, :country_id => state.country.id
      expect(response.body).to match state.name
    end
  end
end
