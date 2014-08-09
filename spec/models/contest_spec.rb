require 'rails_helper'

RSpec.describe Contest, :type => :model do
  describe 'validation' do
    let(:contest) { FactoryGirl.build(:contest) }

    it 'has a valid factory' do
      expect(contest).to be_valid
    end

    it 'should be invalid without a year' do
      contest.year = nil
      expect(contest).to be_invalid
    end

    it 'should be invalid without a name' do
      contest.name = nil
      expect(contest).to be_invalid
    end

    it 'should be invalid without an open date' do
      contest.open_date = nil
      expect(contest).to be_invalid
    end

    it 'should be invalid without a close date' do
      contest.close_date = nil
      expect(contest).to be_invalid
    end

    it 'should be invalid if close date is before open date' do
      contest.open_date = DateTime.now
      expect(contest).to be_invalid
    end

    it 'should respond to categories' do
      expect(contest).to respond_to(:categories)
    end
  end

  describe 'methods' do
    let(:contest) { FactoryGirl.build(:contest) }

    describe 'is_open?' do
      it 'should return false when the contest has not started' do
        contest.open_date = 1.day.from_now
        expect(contest.is_open?).to eq(false)
      end

      it 'should return false when the contest has ended' do
        contest.close_date = 1.day.ago
        expect(contest.is_open?).to eq(false)
      end

      it 'should return true when the contest is open' do
        contest.open_date  = 1.day.ago
        contest.close_date = 1.day.from_now
        expect(contest.is_open?).to eq(true)
      end
    end

    describe 'has_started?' do
      it 'should return false when the contest has not started' do
        contest.open_date = 1.day.from_now
        expect(contest.has_started?).to eq(false)
      end

      it 'should return true when the contest has started' do
        contest.open_date = 1.day.ago
        expect(contest.has_started?).to eq(true)
      end
    end

    describe 'has_ended?' do
      it 'should return false when the contest has not ended' do
        contest.close_date = 1.day.from_now
        expect(contest.has_ended?).to eq(false)
      end

      it 'should return true when the contest has ended' do
        contest.close_date = 1.day.ago
        expect(contest.has_ended?).to eq(true)
      end
    end
  end 
end
