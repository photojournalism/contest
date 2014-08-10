require 'rails_helper'

RSpec.describe ContestRules, :type => :model do
  describe 'validation' do
    let(:contest_rules) { FactoryGirl.build(:contest_rules)}

    it 'should have a valid factory' do
      expect(contest_rules).to be_valid
    end

    it 'should be invalid without text' do
      contest_rules.text = nil
      expect(contest_rules).to be_invalid
    end
  end
end
