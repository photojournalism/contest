require 'rails_helper'

RSpec.describe EntriesController, :type => :controller do
  render_views

  describe "GET new" do
    before(:each) { controller.class.skip_before_action :authenticate_user!}
    before(:all) { FactoryGirl.create(:contest) }
    let(:contest) { Contest.current }
    let(:category) { FactoryGirl.create(:category) }

    it "should display notification when contest hasn't started" do
      set_contest_dates(1.day.from_now, 3.days.from_now)
      get :new
      expect(response.body).to match 'will open on'
    end

    it 'should display notification when contest has ended' do
      set_contest_dates(3.days.ago, 1.day.ago)
      get :new
      expect(response.body).to match 'ended'
    end

    it 'assigns @catgories when contest is open' do
      set_contest_dates(3.days.ago, 1.day.from_now)
      category.save
      contest.categories << category
      get :new
      expect(assigns(:categories)).to eq([category])
    end

    def set_contest_dates(open_date, close_date)
      contest.open_date = open_date
      contest.close_date = close_date
      contest.save
    end
  end
end
