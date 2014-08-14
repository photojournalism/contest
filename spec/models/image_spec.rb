require 'rails_helper'

RSpec.describe Image, :type => :model do
  describe 'validation' do
    let(:image) { FactoryGirl.build(:image) }

    it 'should have a valid factory' do
      expect(image).to be_valid
    end

    it 'should be invalid without a filename' do
      image.filename = nil
      expect(image).to be_invalid
    end

    it 'should be invalid without an original filename' do
      image.original_filename = nil
      expect(image).to be_invalid
    end

    it 'should be invalid without a size' do
      image.size = nil
      expect(image).to be_invalid
    end

    it 'should be invalid without a hash' do
      image.unique_hash = nil
      expect(image).to be_invalid
    end

    it 'should be invalid without a location' do
      image.location = nil
      expect(image).to be_invalid
    end

    it 'should be invalid without an entry' do
      image.entry = nil
      expect(image).to be_invalid
    end

    it 'should be invalid without a caption' do
      image.caption = nil
      expect(image).to be_invalid
    end

    it 'should be invalid without a number' do
      image.number = nil
      expect(image).to be_invalid
    end
  end
end
