require 'rails_helper'

RSpec.describe FileType, :type => :model do
  let(:file_type) { FactoryGirl.build(:file_type) }

  describe 'validation' do

    it 'has a valid factory' do
      expect(file_type).to be_valid
    end

    it 'should be invalid without a name' do
      file_type.name = nil
      expect(file_type).to be_invalid
    end

    it 'should be invalid without an extension' do
      file_type.extension = nil
      expect(file_type).to be_invalid
    end
  end

  describe 'methods' do
    describe 'to_s' do
      it 'should return the extension' do
        expect(file_type.to_s).to eq(file_type.extension)
      end
    end
  end
end
