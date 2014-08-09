require 'rails_helper'

RSpec.describe EntriesController, :type => :controller do
  render_views

  describe "GET new" do
    before(:each) { controller.class.skip_before_action :authenticate_user!}
    before(:all) { FactoryGirl.create(:contest) }
    let(:contest) { Contest.current }

    it "should display notification when contest hasn't started" do
      contest.close_date = 3.days.from_now
      contest.open_date = 1.day.from_now
      contest.save

      get :new
      expect(response.body).to match 'will open on'
    end

    it 'should display notification when contest has ended' do
      contest.close_date = 1.day.ago
      contest.open_date = 3.days.ago
      contest.save
      
      get :new
      expect(response.body).to match 'ended'
    end
  end
end
