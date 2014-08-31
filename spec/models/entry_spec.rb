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

    it 'should be valid without a place' do
      entry.place = nil
      expect(entry).to be_valid
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

    it 'should be invalid without unique_hash' do
      entry.unique_hash = nil
      expect(entry).to be_invalid
    end

    it 'should be invalid without a contest' do
      entry.contest = nil
      expect(entry).to be_invalid
    end

    it 'should be valid without order number' do
      entry.order_number = nil
      expect(entry).to be_valid
    end
  end

  describe 'methods' do
    describe 'delete' do

      it 'should delete entry' do
        entry = FactoryGirl.create(:entry)

        expect {
          entry.delete
        }.to change(Entry, :count).by(-1)
      end

      it 'should delete images' do
        entry = FactoryGirl.create(:entry)
        FactoryGirl.create(:image, :entry => entry)

        expect {
          entry.delete
        }.to change(Image, :count).by(-1)
      end
    end

    describe 'delete_all' do

      it 'should delete all entries' do
        entry1 = FactoryGirl.create(:entry)
        entry2 = FactoryGirl.create(:entry)
        entry3 = FactoryGirl.create(:entry)

        expect {
          Entry.delete_all
        }.to change(Entry, :count).by(-3)
      end

      it 'should delete all images' do
        entry1 = FactoryGirl.create(:entry)
        FactoryGirl.create(:image, :entry => entry1)
        FactoryGirl.create(:image, :entry => entry1)

        entry2 = FactoryGirl.create(:entry)
        FactoryGirl.create(:image, :entry => entry2)
        FactoryGirl.create(:image, :entry => entry2)

        expect {
          Entry.delete_all
        }.to change(Image, :count).by(-4)
      end
    end

    describe 'formatted_created_at' do
      it 'should display formatted date' do
        entry = FactoryGirl.create(:entry)
        expect(entry.formatted_created_at).to eq(entry.created_at.strftime("%A, %b. %-d, %Y at %-I:%M%P %Z"))
      end
    end

    describe 'edit_url' do
      it 'should return the edit url' do
        entry = FactoryGirl.create(:entry)
        expect(entry.edit_url).to eq("/entries/#{entry.unique_hash}")
      end
    end
  end
end
