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

    it 'should be invalid without a hash' do
      image.unique_hash = nil
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

  describe 'methods' do
    describe 'delete_all' do
      it 'should delete all images' do
        image1 = FactoryGirl.create(:image)
        image2 = FactoryGirl.create(:image)
        image3 = FactoryGirl.create(:image)
        image4 = FactoryGirl.create(:image)

        expect {
          Image.delete_all
        }.to change(Image, :count).by(-4)
      end
    end

    describe 'delete' do
      it 'should delete the image' do
        image = FactoryGirl.create(:image)
        expect {
          image.delete
        }.to change(Image, :count).by(-1)
      end
    end

    describe 'extension' do
      it 'should return the extension lowercase without a period' do
        image = FactoryGirl.create(:image, :filename => 'test.JPG')
        expect(image.extension).to eq('jpg')
      end
    end

    describe 'thumbnail_path' do
      it 'should return the path followed by thumbnails' do
        image = FactoryGirl.create(:image)
        expect(image.thumbnail_path).to eq("#{image.location}/thumbnails/#{image.filename}")
      end
    end 

    describe 'public url' do
      it 'should return the public url' do
        image = FactoryGirl.create(:image)
        expect(image.public_url).to eq("/images/contest/#{image.entry.contest.year}/#{image.entry.category.slug}/#{image.entry.unique_hash}/#{image.filename}")
      end
    end
  end
end
