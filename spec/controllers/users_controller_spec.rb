require 'rails_helper'

RSpec.describe UsersController, :type => :controller do
  render_views
  let(:user) { FactoryGirl.create(:user, :admin => true) }

  describe "GET index" do
    it "assigns @users" do
      sign_in user
      get :index
      expect(assigns(:users)).to eq([user])
    end

    it "renders the index template" do
      sign_in user
      get :index
      expect(response).to render_template(:index)
    end

    it "has Administration header" do
      sign_in user
      get :index
      expect(response.body).to match "Administration"
    end

    it "has active Users navigation" do
      sign_in user
      get :index
      expect(response.body).to match '<li class="active"><a href="/admin/users">Users</a></li>'
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

  describe 'GET show' do
    it 'assigns @user' do
      sign_in user
      user = FactoryGirl.create(:user)
      get :show, :id => user.id
      expect(assigns(:user)).to eq(user)
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
