require 'rails_helper'

RSpec.describe Entry, :type => :model do
  describe 'validation' do
    let(:entry) { FactoryGirl.create(:entry) }

    it 'should have a valid factory' do
      expect(entry).to be_valid
    end

    it 'should be invalid without a category' do
      entry.category = nil
      expect(entry).to be_invalid
    end

    it 'should be invalid without a place' do
      entry.place = nil
      expect(entry).to be_invalid
    end

    it 'should be invalid without a user' do
      entry.user = nil
      expect(entry).to be_invalid
    end

    it 'should be invalid without judged' do
      entry.judged = nil
      expect(entry).to be_invalid
    end

    it 'should be valid without url' do
      entry.url = nil
      expect(entry).to be_valid
    end

    it 'should be invalid without uuid' do
      entry.uuid = nil
      expect(entry).to be_invalid
    end

    it 'should be valid without order number' do
      entry.order_number = nil
      expect(entry).to be_valid
    end
  end
end
