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
end
