require 'rails_helper'

RSpec.describe EntriesController, :type => :controller do
  render_views
  let(:user) { FactoryGirl.create(:user) }
  before(:all) { FactoryGirl.create(:contest) }
  after(:all) { Contest.delete_all }

  describe 'GET index' do
    let(:contest) { Contest.current }
    let(:completed_entry) { FactoryGirl.create(:entry, :contest => contest, :pending => false, :user => user) }
    let(:pending_entry) { FactoryGirl.create(:entry, :contest => contest, :pending => true, :user => user) }

    describe 'with signed in user' do
      before(:each) do
        sign_in user
        completed_entry.save
        pending_entry.save
      end

      it 'should assign @contest' do
        get :index
        expect(assigns(:contest)).to eq(contest)
      end

      it 'should assign @completed_entries' do
        get :index
        expect(assigns(:completed_entries)).to eq([completed_entry])
      end

      it 'should assign @pending_entries' do
        get :index
        expect(assigns(:pending_entries)).to eq([pending_entry])
      end
    end

    describe 'with not signed in user' do
      it 'should redirect to login page' do
        get :new
        expect(response).to redirect_to(new_user_session_path)
      end
    end
    
  end

  describe "GET new" do
    let(:contest) { Contest.current }
    let(:category) { FactoryGirl.create(:category) }

    it 'should redirect to login page when not logged in' do
      get :new
      expect(response).to redirect_to(new_user_session_path)
    end

    it "should display notification when contest hasn't started" do
      sign_in user
      set_contest_dates(1.day.from_now, 3.days.from_now)
      get :new
      expect(response.body).to match 'will open on'
      sign_out user
    end

    it 'should display notification when contest has ended' do
      sign_in user
      set_contest_dates(3.days.ago, 1.day.ago)
      get :new
      expect(response.body).to match 'ended'
      sign_out user
    end

    it 'assigns @categories when contest is open and an agreement for user exists' do
      sign_in user
      set_contest_dates(3.days.ago, 1.day.from_now)
      category.save
      contest.categories << category
      agreement = Agreement.create(:contest => contest, :user => user)

      get :new
      expect(assigns(:categories)).to eq([category])
      sign_out user
    end

    it 'renders new template when contest is open and an agreement for user exists' do
      sign_in user
      set_contest_dates(3.days.ago, 1.day.from_now)
      category.save
      contest.categories << category
      agreement = Agreement.create(:contest => contest, :user => user)

      get :new
      expect(response).to render_template(:new)
      sign_out user
    end

    it "redirects to new agreement when one doesn't exist" do
      sign_in user
      set_contest_dates(3.days.ago, 1.day.from_now)
      get :new
      expect(response).to redirect_to(new_agreement_path)
      sign_out user
    end

    def set_contest_dates(open_date, close_date)
      contest.open_date = open_date
      contest.close_date = close_date
      contest.save
    end
  end

  describe 'POST create' do
    let (:category) { FactoryGirl.create(:category) }
    it 'should create a new entry with valid params' do
      sign_in user
      expect {
        post :create, :entry => { :category => category.id, :order_number => 'asdf' }
      }.to change(Entry, :count).by(1)
    end

    it 'should respond with json url on success' do
      sign_in user
      post :create, :entry => { :category => category.id, :order_number => 'asdf' }
      expect(response.body).to match 'url'
    end

    it 'should respond with json error on failure' do
      sign_in user
      Contest.delete_all
      post :create, :entry => { :category => category.id, :order_number => 'asdf' }
      FactoryGirl.create(:contest)
      expect(response.body).to match 'message'
    end

    it 'should redirect for not logged in user' do
      post :create, :entry => { :category => category.id, :order_number => 'asdf' }
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe 'GET show' do
    let(:entry) { FactoryGirl.create(:entry, :user => user) }

    it 'should redirect for not logged in user' do
      get :show, :hash => entry.unique_hash
      expect(response).to redirect_to(new_user_session_path)
    end

    it 'should show for valid entry and user' do
      sign_in user
      get :show, :hash => entry.unique_hash
      expect(response.body).to match entry.category.name
    end

    it 'should not show if the user is not the right user' do
      sign_in user
      entry.user = FactoryGirl.create(:user)
      entry.save
      
      get :show, :hash => entry.unique_hash
      expect(response).to redirect_to(new_entry_path)
    end

    it 'should show if the user is admin' do
      user.admin = true
      user.save

      sign_in user
      entry.user = FactoryGirl.create(:user)
      get :show, :hash => entry.unique_hash
      expect(response.body).to match entry.category.name
    end

    it 'should redirect if the hash was wrong' do
      sign_in user
      get :show, :hash => 'asdf'
      expect(response.body).to redirect_to(new_entry_path)
    end
  end

  describe 'GET confirmation' do
    let(:completed_entry) { FactoryGirl.create(:entry, :user => user, :pending => false) }
    let(:pending_entry) { FactoryGirl.create(:entry, :user => user, :pending => true) }

    describe 'with signed in user' do
      before(:each) { sign_in user }

      describe 'with completed entry' do
        it 'assigns @entry' do
          get :confirmation, :hash => completed_entry.unique_hash
          expect(assigns(:entry)).to eq(completed_entry)
        end

        it 'should render the confirmation view' do
          get :confirmation, :hash => completed_entry.unique_hash
          expect(response.body).to match("Entry Submission Confirmation")
        end
      end

      describe 'with pending entry' do
        it 'assigns @entry' do
          get :confirmation, :hash => pending_entry.unique_hash
          expect(assigns(:entry)).to eq(pending_entry)
        end

        it 'should redirect to Entries#show' do
          get :confirmation, :hash => pending_entry.unique_hash
          expect(response).to redirect_to("/entries/#{pending_entry.unique_hash}")
        end
      end

      describe 'with no entry' do
        it 'should redirect to the new entry path' do
          get :confirmation, :hash => ''
          expect(response).to redirect_to(new_entry_path)
        end
      end
    end
  end

  describe 'PUT update' do
    let(:entry) { FactoryGirl.create(:entry, :user => user) }

    before(:each) do
      entry.contest.open_date = 3.days.ago
      entry.contest.close_date = 3.days.from_now
      entry.contest.save
    end

    context 'with valid params' do

      it 'should find the correct entry' do
        sign_in user
        put :update, :hash => entry.unique_hash, :url => 'random url'
        expect(assigns(:entry)).to eq(entry)
      end

      it 'should update the entry with when contest is open' do
        sign_in user

        put :update, :hash => entry.unique_hash, :url => 'https://github.com'
        expect(response.body).to match('Success')
        entry.reload
        expect(entry.url).to eq('https://github.com')
      end

      it 'should not update the entry with when contest is closed' do
        sign_in user
        entry.contest.close_date = 3.days.ago
        entry.contest.save

        put :update, :hash => entry.unique_hash, :url => 'https://github.com'
        expect(response.body).to match('no longer allowed to be updated')
        entry.reload
        expect(entry.url).to_not eq('https://github.com')
      end
    end

    context 'with invalid params' do
      it 'should not update the entry' do
        sign_in user
        put :update, :hash => entry.unique_hash, :url => 123
        expect(entry.url).to_not eq(123)
      end
    end

    context 'when not logged in' do
      it 'should redirect to the login page' do
        put :update, :hash => entry.unique_hash, :url => 'https://google.com'
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when not the correct user' do
      it 'should not update the entry' do
        sign_in user
        entry.user = FactoryGirl.create(:user)
        entry.save

        put :update, :hash => entry.unique_hash, :url => 'https://google.com'
        expect(response.status).to eq(500)
      end

      it 'should update the entry if the user is admin' do
        sign_in user
        entry.user = FactoryGirl.create(:user)
        entry.save

        user.admin = true
        user.save

        put :update, :hash => entry.unique_hash, :url => 'https://github.com'
        expect(response.body).to match('Success')
        entry.reload
        expect(entry.url).to eq('https://github.com')
      end
    end
  end

  describe 'DELETE destroy' do
    let(:entry) { FactoryGirl.create(:entry, :user => user) }

    before(:each) do
      entry.contest.open_date = 3.days.ago
      entry.contest.close_date = 3.days.from_now
      entry.contest.save
    end

    context 'with valid params' do
      it 'should find the entry' do
        sign_in user
        delete :destroy, :hash => entry.unique_hash
        expect(assigns(:entry)).to eq(entry)
      end

      it 'should delete the entry' do
        sign_in user
        expect {
          delete :destroy, :hash => entry.unique_hash
        }.to change(Entry, :count).by(-1)
      end

      it 'should not delete the entry when the contest is closed' do
        entry.contest.close_date = 3.days.ago
        entry.contest.save

        sign_in user
        expect {
          delete :destroy, :hash => entry.unique_hash
        }.to change(Entry, :count).by(0)
      end
    end

    context 'with invalid params' do
      it 'should not find the entry' do
        sign_in user
        delete :destroy, :hash => 'asdf'
        expect(assigns(:entry)).to_not eq(entry)
      end

      it 'should not delete the entry' do
        sign_in user
        expect {
          delete :destroy, :hash => 'asdf'
        }.to change(Entry, :count).by(0)
      end
    end

    context 'when not logged in' do
      it 'should not delete the entry' do
        expect {
          delete :destroy, :hash => entry.unique_hash
        }.to change(Entry, :count).by(0)
      end

      it 'should redirect to the login page' do
        delete :destroy, :hash => entry.unique_hash
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
