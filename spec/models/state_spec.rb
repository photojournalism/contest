require 'rails_helper'

RSpec.describe State, :type => :model do
  describe 'validation' do
    let(:state) { FactoryGirl.build(:state) }

    it 'has a valid factory' do
      expect(state).to be_valid
    end

    it 'should be invalid without a name' do
      state.name = nil
      expect(state).to be_invalid
    end

    it 'should be invalid without an iso code' do
      state.iso = nil
      expect(state).to be_invalid
    end

    it 'should be invalid without a country' do
      state.country = nil
      expect(state).to be_invalid
    end
  end
end