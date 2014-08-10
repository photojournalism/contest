require 'rails_helper'

RSpec.describe CategoryType, :type => :model do
  describe 'validation' do
    let(:category_type) { FactoryGirl.build(:category_type) }

    it 'should have a valid factory' do
      expect(category_type).to be_valid
    end

    it 'should be invalid without a name' do
      category_type.name = nil
      expect(category_type).to be_invalid
    end

    it 'should be invalid without a description' do
      category_type.description = nil
      expect(category_type).to be_invalid
    end

    it 'should be invalid without minimum files' do
      category_type.minimum_files = nil
      expect(category_type).to be_invalid
    end

    it 'should be invalid without maximum files' do
      category_type.maximum_files = nil
      expect(category_type).to be_invalid
    end

    it 'should be invalid if maximum is less than minumum files' do
      category_type.minimum_files = 1
      category_type.maximum_files = 0
      expect(category_type).to be_invalid
    end

    it 'should be invalid without an active flag' do
      category_type.active = nil
      expect(category_type).to be_invalid
    end

    it 'should be invalid without a has_url flag' do
      category_type.has_url = nil
      expect(category_type).to be_invalid
    end
  end
end
