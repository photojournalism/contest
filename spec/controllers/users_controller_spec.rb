require 'rails_helper'

RSpec.describe UsersController, :type => :controller do
  render_views

  describe "GET index" do
    before(:each) { controller.class.skip_before_filter :require_admin }

    it "assigns @users" do
      user = FactoryGirl.create(:user)
      get :index
      expect(assigns(:users)).to eq([user])
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template(:index)
    end

    it "has Administration header" do
      get :index
      expect(response.body).to match "Administration"
    end

    it "has active Users navigation" do
      get :index
      expect(response.body).to match '<li class="active"><a href="/admin/users">Users</a></li>'
    end
  end

  describe 'GET show' do
    before(:each) { controller.class.skip_before_filter :require_admin }

    it 'assigns @user' do
      user = FactoryGirl.create(:user)
      get :show, :id => user.id
      expect(assigns(:user)).to eq(user)
    end
  end
end
