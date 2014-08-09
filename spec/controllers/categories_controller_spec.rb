require 'rails_helper'

RSpec.describe CategoriesController, :type => :controller do
  render_views

  describe "GET index" do
    before(:each) { controller.class.skip_before_filter :require_admin }

    it "assigns @categories" do
      category = FactoryGirl.create(:category)
      get :index
      expect(assigns(:categories)).to eq([category])
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template(:index)
    end

    it "has Administration header" do
      get :index
      expect(response.body).to match "Administration"
    end

    it "has active Categories navigation" do
      get :index
      expect(response.body).to match '<li class="active"><a href="/admin/categories">Categories</a></li>'
    end
  end
end
