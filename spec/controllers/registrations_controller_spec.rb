require 'rails_helper'

RSpec.describe RegistrationsController, :type => :controller do
  describe "GET new" do
    let(:state) { FactoryGirl.create(:state) }
    let(:country) { FactoryGirl.create(:country) }
    
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
    end

    it "assigns @states" do
      state.save
      get :new
      expect(assigns(:states)).to eq([state])
    end

    it "assigns @countries" do
      state.save
      get :new
      expect(assigns(:countries)).to eq([state.country])
    end

    it "assigns @us when United States exists" do
      country.name = 'United States'
      country.save
      state.country = country
      state.save

      get :new
      expect(assigns(:countries)).to include(country)
      expect(assigns(:states)).to include(state)
    end
  end
end
