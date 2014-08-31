require 'rails_helper'

RSpec.describe ContactController, :type => :controller do
  let(:user) { FactoryGirl.create(:user) }

  describe 'POST report_a_problem' do
    describe 'with signed in user' do
      before(:each) { sign_in user }

      describe 'with a message' do
        it 'should send an email' do
          expect {
            post :report_a_problem, :message => 'This is a test'
          }.to change { ActionMailer::Base.deliveries.count }.by(1)
        end

        it 'should respond with an error message' do
          post :report_a_problem, :message => 'This is a test'
          expect(response.body).to match('Success')
        end

        it 'should have a 200 error code' do
          post :report_a_problem, :message => 'This is a test'
          expect(response.status).to eq(200)
        end
      end

      describe 'without a message' do
        it 'should not send an email' do
          expect {
            post :report_a_problem
          }.to change { ActionMailer::Base.deliveries.count }.by(0)
        end

        it 'should respond with an error message' do
          post :report_a_problem
          expect(response.body).to match('requires a message')
        end

        it 'should have a 400 error code' do
          post :report_a_problem
          expect(response.status).to eq(400)
        end
      end
    end

    describe 'with no signed in user' do
      it 'should not send an email' do
        expect {
          post :report_a_problem, :message => 'This is a test'
        }.to change { ActionMailer::Base.deliveries.count }.by(0)
      end

      it 'should redirect to login path' do
        post :report_a_problem
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
