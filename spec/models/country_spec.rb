require 'rails_helper'

RSpec.describe Country, :type => :model do

  describe 'validation' do
    let(:country) { FactoryGirl.build(:country) }

    it 'has a valid factory' do
      expect(country).to be_valid
    end

    it 'should be invalid without a name' do
      country.name = nil
      expect(country).to be_invalid
    end

    it 'should be invalid without an iso code' do
      country.iso = nil
      expect(country).to be_invalid
    end
  end
end