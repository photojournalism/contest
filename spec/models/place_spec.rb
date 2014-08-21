require 'rails_helper'

RSpec.describe Place, :type => :model do
  describe 'validation' do
    let(:place) { FactoryGirl.create(:place) }

    it 'should have a valid factory' do
      expect(place).to be_valid
    end

    it 'should be invalid without a name' do
      place.name = nil
      expect(place).to be_invalid
    end

    it 'should be invalid without a sequence number' do
      place.sequence_number = nil
      expect(place).to be_invalid
    end

    it 'should respond to entries' do
      expect(place).to respond_to(:entries)
    end
  end
end
