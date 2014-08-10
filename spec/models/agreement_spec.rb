require 'rails_helper'

RSpec.describe Agreement, :type => :model do
  describe 'validation' do
    let(:agreement) { FactoryGirl.build(:agreement) }
    
    it 'should have a valid factory' do
      expect(agreement).to be_valid
    end

    it 'should be invalid without a user' do
      agreement.user = nil
      expect(agreement).to be_invalid
    end

    it 'should be invalid without a contest' do
      agreement.contest = nil
      expect(agreement).to be_invalid
    end
  end
end
