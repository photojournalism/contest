require 'rails_helper'

RSpec.describe Category, :type => :model do
  describe 'validation' do
    let(:category) { FactoryGirl.build(:category) }

    it 'has a valid factory' do
      expect(category).to be_valid
    end

    it 'should be invalid without a name' do
      category.name = nil
      expect(category).to be_invalid
    end
    
    it 'should be invalid without a description' do
      category.description = nil
      expect(category).to be_invalid
    end

    it 'should be invalid without an active flag' do
      category.active = nil
      expect(category).to be_invalid
    end
  end
end
