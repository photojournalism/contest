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

    it 'should be invalid without a category type' do
      category.category_type = nil
      expect(category).to be_invalid
    end

    it 'should respond to contests' do
      expect(category).to respond_to(:contests)
    end

    it 'should respond to category_type' do
      expect(category).to respond_to(:category_type)
    end
  end

  describe 'methods' do
    let(:category) { FactoryGirl.build(:category) }

    describe 'to_s' do
      it 'should return the name' do
        expect(category.to_s).to eq(category.name)
      end
    end

    describe 'slug' do
      it 'should return lowercase name with dashes' do
        expect(category.slug).to eq(category.name.downcase.gsub(' ', '-'))
      end
    end

    describe 'file_types' do
      it 'should return an array of file types' do
        ft1 = FactoryGirl.create(:file_type)
        ft2 = FactoryGirl.create(:file_type)
        ft3 = FactoryGirl.create(:file_type)
        category.category_type.file_types = [ft1, ft2, ft3]
        expect(category.file_types).to eq(category.category_type.file_types)
      end
    end
  end
end
